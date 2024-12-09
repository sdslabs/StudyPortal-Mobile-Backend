defmodule StudyPortal.BookmarksPinsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StudyPortal.BookmarksPins` context.
  """

  @doc """
  Generate a bookmark_pin.
  """
  def bookmark_pin_fixture(attrs \\ %{}) do
    {:ok, bookmark_pin} =
      attrs
      |> Enum.into(%{
        bookmarks: [1, 2],
        pins: [1, 2],
        userid: 42
      })
      |> StudyPortal.BookmarksPins.create_bookmark_pin()

    bookmark_pin
  end
end
