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

    with {:ok, %FileStorage{} = file_storage} <- Files.update_file_storage(file_storage, file_storage_params) do
      render(conn, :show, file_storage: file_storage)
    end
  end

  def delete(conn, %{"id" => id}) do
    file_storage = Files.get_file_storage!(id)

    with {:ok, %FileStorage{}} <- Files.delete_file_storage(file_storage) do
      send_resp(conn, :no_content, "")
    end
  end
end
