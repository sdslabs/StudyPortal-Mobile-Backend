defmodule StudyPortalWeb.FileStorageJSON do
  alias StudyPortal.Files.FileStorage

  @doc """
  Renders a list of file_storages.
  """
  def index(%{file_storages: file_storages}) do
    %{data: for(file_storage <- file_storages, do: data(file_storage))}
  end

  @doc """
  Renders a single file_storage.
  """
  def show(%{file_storage: file_storage}) do
    %{data: data(file_storage)}
  end

  defp data(%FileStorage{} = file_storage) do
    %{
      id: file_storage.id,
      name: file_storage.name,
      course_code: file_storage.course_code,
      s3_url: file_storage.s3_url,
      status: file_storage.status
    }
  end
end
