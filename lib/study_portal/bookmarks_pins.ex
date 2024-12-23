defmodule StudyPortal.BookmarksPins do
  @moduledoc """
  The BookmarksPins context.
  """

  import Ecto.Query, warn: false
  alias StudyPortal.Repo

  alias StudyPortal.BookmarksPins.BookmarkPin

  @doc """
  Returns the list of bookmarks_pins.

  ## Examples

      iex> list_bookmarks_pins()
      [%BookmarkPin{}, ...]

  """
  def list_bookmarks_pins do
    Repo.all(BookmarkPin)
  end

  @doc """
  Gets a single bookmark_pin.

  Raises `Ecto.NoResultsError` if the Bookmark pin does not exist.

  ## Examples

      iex> get_bookmark_pin!(123)
      %BookmarkPin{}

      iex> get_bookmark_pin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bookmark_pin!(id), do: Repo.get!(BookmarkPin, id)

  @doc """
  Creates a bookmark_pin.

  ## Examples

      iex> create_bookmark_pin(%{field: value})
      {:ok, %BookmarkPin{}}

      iex> create_bookmark_pin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bookmark_pin(attrs \\ %{}) do
    %BookmarkPin{}
    |> BookmarkPin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bookmark_pin.

  ## Examples

      iex> update_bookmark_pin(bookmark_pin, %{field: new_value})
      {:ok, %BookmarkPin{}}

      iex> update_bookmark_pin(bookmark_pin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bookmark_pin(%BookmarkPin{} = bookmark_pin, attrs) do
    bookmark_pin
    |> BookmarkPin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bookmark_pin.

  ## Examples

      iex> delete_bookmark_pin(bookmark_pin)
      {:ok, %BookmarkPin{}}

      iex> delete_bookmark_pin(bookmark_pin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bookmark_pin(%BookmarkPin{} = bookmark_pin) do
    Repo.delete(bookmark_pin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bookmark_pin changes.

  ## Examples

      iex> change_bookmark_pin(bookmark_pin)
      %Ecto.Changeset{data: %BookmarkPin{}}

  """
  def change_bookmark_pin(%BookmarkPin{} = bookmark_pin, attrs \\ %{}) do
    BookmarkPin.changeset(bookmark_pin, attrs)
  end

  def get_bookmarks_pins_by_userid(userid) do
    Repo.get_by(BookmarkPin, userid: userid)
  end
end
