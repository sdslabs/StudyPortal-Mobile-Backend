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
    with {:ok, %BookmarkPin{} = bookmark_pin} <-
           BookmarksPins.create_bookmark_pin(bookmark_pin_params) do
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

    with {:ok, %BookmarkPin{} = bookmark_pin} <-
           BookmarksPins.update_bookmark_pin(bookmark_pin, bookmark_pin_params) do
      render(conn, :show, bookmark_pin: bookmark_pin)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark_pin = BookmarksPins.get_bookmark_pin!(id)

    with {:ok, %BookmarkPin{}} <- BookmarksPins.delete_bookmark_pin(bookmark_pin) do
      send_resp(conn, :no_content, "")
    end
  end

  # TODO: Currently this accepts user_id as a body parameter. Once auth is implemented,
  # This is to be recovered from JWT instead.
  def get_pins(conn, %{"user_id" => user_id}) do
    pins = BookmarksPins.get_bookmarks_pins_by_userid(user_id).pins
    render(conn, :branches, bookmark_pin: pins)
  end

  def get_bookmarks(conn, %{"user_id" => user_id}) do
    bookmarks = BookmarksPins.get_bookmarks_pins_by_userid(user_id).bookmarks
    render(conn, :files, bookmark_pin: bookmarks)
  end

  # TODO: Add some special message if pin/bookmark already exists
  # TODO: Check if branch_id is a valid either by changeset or directly in controller
  def add_pins(conn, %{"user_id" => user_id, "branch_id" => branch_id}) do
    bookmarks_pins = BookmarksPins.get_bookmarks_pins_by_userid(user_id)
    pins = bookmarks_pins.pins
    {branch_id, ""} = Integer.parse(branch_id)
    if branch_id not in pins do
      updated_bookmarks_pins = %BookmarkPin{
        bookmarks_pins
        | pins: [branch_id | bookmarks_pins.pins]
      }
      BookmarksPins.set_bookmarks_pins_by_userid(user_id, updated_bookmarks_pins)
    end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Jason.encode!("Bookmark Added"))
    # render(conn, :files, bookmark_pin: bookmarks_pins)
  end
end
