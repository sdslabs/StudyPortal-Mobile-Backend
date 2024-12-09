defmodule StudyPortalWeb.BookmarkPinJSON do
  alias StudyPortal.BookmarksPins.BookmarkPin

  @doc """
  Renders a list of bookmarks_pins.
  """
  def index(%{bookmarks_pins: bookmarks_pins}) do
    %{data: for(bookmark_pin <- bookmarks_pins, do: data(bookmark_pin))}
  end

  @doc """
  Renders a single bookmark_pin.
  """
  def show(%{bookmark_pin: bookmark_pin}) do
    %{data: data(bookmark_pin)}
  end

  defp data(%BookmarkPin{} = bookmark_pin) do
    %{
      id: bookmark_pin.id,
      userid: bookmark_pin.userid,
      bookmarks: bookmark_pin.bookmarks,
      pins: bookmark_pin.pins
    }
  end
end
