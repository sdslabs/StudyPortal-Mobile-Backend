defmodule StudyPortalWeb.BookmarkPinController do
  use StudyPortalWeb, :controller

  alias StudyPortal.BookmarksPins
  alias StudyPortal.BookmarksPins.BookmarkPin

  action_fallback StudyPortalWeb.FallbackController

  def index(conn, _params) do
    bookmarks_pins = BookmarksPins.list_bookmarks_pins()
    render(conn, :index, bookmarks_pins: bookmarks_pins)
  end

  def create(conn, %{"bookmark_pin" => bookmark_pin_params}) do
    with {:ok, %BookmarkPin{} = bookmark_pin} <- BookmarksPins.create_bookmark_pin(bookmark_pin_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/bookmarks_pins/#{bookmark_pin}")
      |> render(:show, bookmark_pin: bookmark_pin)
    end
  end

  def show(conn, %{"id" => id}) do
    bookmark_pin = BookmarksPins.get_bookmark_pin!(id)
    render(conn, :show, bookmark_pin: bookmark_pin)
  end

  def update(conn, %{"id" => id, "bookmark_pin" => bookmark_pin_params}) do
    bookmark_pin = BookmarksPins.get_bookmark_pin!(id)

    with {:ok, %BookmarkPin{} = bookmark_pin} <- BookmarksPins.update_bookmark_pin(bookmark_pin, bookmark_pin_params) do
      render(conn, :show, bookmark_pin: bookmark_pin)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark_pin = BookmarksPins.get_bookmark_pin!(id)

    with {:ok, %BookmarkPin{}} <- BookmarksPins.delete_bookmark_pin(bookmark_pin) do
      send_resp(conn, :no_content, "")
    end
  end
end
