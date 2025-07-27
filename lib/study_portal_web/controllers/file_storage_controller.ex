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

    s3_url = file_storage.s3_url
    bucket = System.get_env("S3_BUCKET_NAME")

    object_key =
      s3_url
      |> URI.parse()
      |> Map.get(:path)
      |> String.trim_leading("/")

    s3_deletion_result =
      ExAws.S3.delete_object(bucket, object_key)
      |> ExAws.request()

    case s3_deletion_result do
      {:ok, _response} ->
        with {:ok, %FileStorage{}} <- Files.delete_file_storage(file_storage) do
          conn
          |> put_status(:ok)
          |> json(%{message: "File successfully deleted from S3 and database"})
        end

      {:error, reason} ->
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
  def give_put_url(conn, %{
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
              {:ok, file_storage} ->
                json(conn, %{url: presigned_url, id: file_storage.id})

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

  @doc """
  Generates a presigned URL for downloading a file from the S3 bucket.
  """
  def give_get_url(conn, %{"id" => id}) do
    case Files.get_file_storage!(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          error: "Failed to generate presigned URL",
          reason: "File storage record with id #{id} not found."
        })

      file_storage ->
        bucket_name = System.get_env("S3_BUCKET_NAME")
        region = System.get_env("S3_REGION")

        s3_url = file_storage.s3_url

        object_key =
          s3_url
          |> URI.parse()
          |> Map.get(:path)
          |> String.trim_leading("/")

        presign_options = [
          query_params: [],
          expires_in: 3600
        ]

        case ExAws.Config.new(:s3, region: region)
             |> ExAws.S3.presigned_url(:get, bucket_name, object_key, presign_options) do
          {:ok, presigned_url} ->
            json(conn, %{url: presigned_url})

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{
              error: "Failed to generate presigned URL",
              reason: reason
            })
        end
    end
  end

  @doc """
  Marks the file as "pending" in the database after the upload is complete.
  AWS responds with confirmation for a completed upload, and this endpoint updates the database.
  """
  def upload_file_complete(conn, %{"id" => id}) do
    case Files.get_file_storage!(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          error: "File not found",
          reason: "File storage record with id #{id} not found."
        })

      file_storage ->
        case Files.update_file_storage(file_storage, %{status: "pending"}) do
          {:ok, _updated_file_storage} ->
            conn
            |> put_status(:ok)
            |> json(%{
              message: "File status updated to 'pending'",
            })

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              error: "Failed to update file status",
              reason: changeset
            })
        end
    end
  end
end
