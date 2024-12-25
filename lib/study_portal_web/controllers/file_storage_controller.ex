defmodule StudyPortalWeb.FileStorageController do
  use StudyPortalWeb, :controller

  alias StudyPortal.Files
  alias StudyPortal.Files.FileStorage

  action_fallback StudyPortalWeb.FallbackController

  def index(conn, _params) do
    file_storages = Files.list_file_storages()
    render(conn, :index, file_storages: file_storages)
  end

  def create(conn, %{"file_storage" => file_storage_params}) do
    with {:ok, %FileStorage{} = file_storage} <- Files.create_file_storage(file_storage_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/file_storages/#{file_storage}")
      |> render(:show, file_storage: file_storage)
    end
  end

  def show(conn, %{"id" => id}) do
    file_storage = Files.get_file_storage!(id)
    render(conn, :show, file_storage: file_storage)
  end

  def update(conn, %{"id" => id, "file_storage" => file_storage_params}) do
    file_storage = Files.get_file_storage!(id)

    with {:ok, %FileStorage{} = file_storage} <-
           Files.update_file_storage(file_storage, file_storage_params) do
      render(conn, :show, file_storage: file_storage)
    end
  end

  def delete(conn, %{"id" => id}) do
    file_storage = Files.get_file_storage!(id)

    # Extract bucket and object key from the S3 URL
    s3_url = file_storage.s3_url
    # Replace with your bucket name
    bucket = "your-s3-bucket-name"
    object_key = URI.parse(s3_url).path |> String.trim_leading("/")

    # Attempt to delete the file from the S3 bucket
    s3_deletion_result =
      ExAws.S3.delete_object(bucket, object_key)
      |> ExAws.request()

    case s3_deletion_result do
      {:ok, _response} ->
        # If the file is successfully deleted from S3, delete the DB record
        with {:ok, %FileStorage{}} <- Files.delete_file_storage(file_storage) do
          send_resp(conn, :no_content, "")
        end

      {:error, reason} ->
        # Handle S3 deletion failure
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Failed to delete file from S3", details: reason})
    end
  end

  @doc """
  Fetches all files with a 'pending' status.
  """
  def pending_files(conn, _params) do
    pending_files = Files.get_files_by_status("pending")

    render(conn, "index.json", file_storages: pending_files)
  end

  @doc """
  Generates a simple presigned URL for uploading a file to the S3 bucket.
  """
  def give_url(conn, %{
        "course_code" => course_code,
        "filename" => filename,
        "description" => description,
        "type" => type
      }) do
    bucket_name = System.get_env("S3_BUCKET_NAME")
    region = System.get_env("S3_REGION")
    object_key = "#{course_code}/#{type}/#{filename}"

    presign_options = [
      query_params: [{"ContentType", "application/octet-stream"}, {"ACL", "private"}],
      expires_in: 3600
    ]

    case StudyPortal.Repo.get_by(StudyPortal.Courses.Course, course_code: course_code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          error: "Failed to generate presigned URL",
          reason: "Course with course_code #{course_code} not found."
        })

      course ->
        case ExAws.Config.new(:s3, region: region)
             |> ExAws.S3.presigned_url(:put, bucket_name, object_key, presign_options) do
          {:ok, presigned_url} ->
            file_storage_attrs = %{
              name: filename,
              description: description,
              type: type,
              course_id: course.id,
              s3_url: "https://#{bucket_name}.s3.#{region}.amazonaws.com/#{object_key}",
              status: "not_uploaded"
            }

            case StudyPortal.Files.create_file_storage(file_storage_attrs) do
              {:ok, _file_storage} ->
                json(conn, %{url: presigned_url})

              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{error: "Failed to save file record", reason: changeset})
            end

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Failed to generate presigned URL", reason: reason})
        end
    end
  end
end
