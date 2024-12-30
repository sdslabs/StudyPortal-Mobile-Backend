defmodule StudyPortal.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false
  alias StudyPortal.Repo

  alias StudyPortal.Files.FileStorage

  @doc """
  Returns the list of file_storages.

  ## Examples

      iex> list_file_storages()
      [%FileStorage{}, ...]

  """
  def list_file_storages do
    Repo.all(FileStorage)
  end

  @doc """
  Gets a single file_storage.

  Raises `Ecto.NoResultsError` if the File storage does not exist.

  ## Examples

      iex> get_file_storage!(123)
      %FileStorage{}

      iex> get_file_storage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file_storage!(id), do: Repo.get!(FileStorage, id)

  @doc """
  Creates a file_storage.

  ## Examples

      iex> create_file_storage(%{field: value})
      {:ok, %FileStorage{}}

      iex> create_file_storage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file_storage(attrs \\ %{}) do
    %FileStorage{}
    |> FileStorage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file_storage.

  ## Examples

      iex> update_file_storage(file_storage, %{field: new_value})
      {:ok, %FileStorage{}}

      iex> update_file_storage(file_storage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file_storage(%FileStorage{} = file_storage, attrs) do
    file_storage
    |> FileStorage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file_storage.

  ## Examples

      iex> delete_file_storage(file_storage)
      {:ok, %FileStorage{}}

      iex> delete_file_storage(file_storage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file_storage(%FileStorage{} = file_storage) do
    Repo.delete(file_storage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file_storage changes.

  ## Examples

      iex> change_file_storage(file_storage)
      %Ecto.Changeset{data: %FileStorage{}}

  """
  def change_file_storage(%FileStorage{} = file_storage, attrs \\ %{}) do
    FileStorage.changeset(file_storage, attrs)
  end


  @doc """
  Fetches files with a given status.

  ## Examples

      iex> get_files_by_status("pending")
      [%FileStorage{}, ...]

  """
  def get_files_by_status(status) do
    Repo.all(from fs in FileStorage, where: fs.status == ^status)
  end

end
