defmodule StudyPortalWeb.BookmarkPinController do
  use StudyPortalWeb, :controller

  alias StudyPortal.BookmarksPins
  alias StudyPortal.BookmarksPins.BookmarkPin
  alias StudyPortal.Users

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

  def get_pins(conn, %{}) do
    user_id = conn.assigns.current_user.id

    case BookmarksPins.get_bookmarks_pins_by_userid(user_id) do
      nil -> render(conn, :branches, bookmark_pin: [])
      bp  -> render(conn, :branches, bookmark_pin: bp.pins)
    end
  end


  def get_bookmarks(conn, %{}) do
    user_id = conn.assigns.current_user.id

    case BookmarksPins.get_bookmarks_pins_by_userid(user_id) do
      nil -> render(conn, :files, bookmark_pin: [])
      bp  -> render(conn, :files, bookmark_pin: bp.bookmarks)
    end
  end

  def add_pin(conn, %{"branch_id" => branch_id}) do
    try do
      user_id = user_id = conn.assigns.current_user.id

      bookmarks_pins =
        case BookmarksPins.get_bookmarks_pins_by_userid(user_id) do
          nil ->
            new_bookmark = %BookmarkPin{
              userid: user_id,
              bookmarks: [],
              pins: []
            }
            {:ok, added_bookmark} = BookmarksPins.create_bookmark_pin(Map.from_struct(new_bookmark))
            added_bookmark
          existing_bp ->
            existing_bp
        end

      pins = bookmarks_pins.pins
      {branch_id, ""} = Integer.parse(branch_id)

      if branch_id not in pins do
        updated_bookmarks_pins = %BookmarkPin{
          bookmarks_pins
          | pins: [branch_id | pins]
        }

        BookmarksPins.update_bookmark_pin(bookmarks_pins, %{
          pins: updated_bookmarks_pins.pins
        })
      end

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(201, Jason.encode!("Pin Added"))
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!("User does not exist"))

    end
  end

  def add_bookmark(conn, %{"user_id" => user_id, "file_id" => file_id}) do
    try do
      user_id = conn.assigns.current_user.id

      bookmarks_pins =
        case BookmarksPins.get_bookmarks_pins_by_userid(user_id) do
          nil ->
            new_bookmark = %BookmarkPin{
              userid: user_id,
              bookmarks: [],
              pins: []
            }
            {:ok, added_bookmark} = BookmarksPins.create_bookmark_pin(Map.from_struct(new_bookmark))
            added_bookmark
          existing_bp ->
            existing_bp
        end

      bookmarks = bookmarks_pins.bookmarks
      {file_id, ""} = Integer.parse(file_id)

      if file_id not in bookmarks do
        updated_bookmarks_pins = %BookmarkPin{
          bookmarks_pins
          | bookmarks: [file_id | bookmarks]
        }

        BookmarksPins.update_bookmark_pin(bookmarks_pins, %{
          bookmarks: updated_bookmarks_pins.bookmarks
        })
      end

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(201, Jason.encode!("Bookmark Added"))
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!("User does not exist"))

    end
  end

  def remove_pin(conn, %{"user_id" => user_id, "branch_id" => branch_id}) do
    try do
      user_id = conn.assigns.current_user.id

      bookmarks_pins =
        case BookmarksPins.get_bookmarks_pins_by_userid(user_id) do
          nil ->
            new_bookmark = %BookmarkPin{
              userid: user_id,
              bookmarks: [],
              pins: []
            }
            {:ok, added_bookmark} = BookmarksPins.create_bookmark_pin(Map.from_struct(new_bookmark))
            added_bookmark
          existing_bp ->
            existing_bp
        end
      pins = bookmarks_pins.pins
      {branch_id, ""} = Integer.parse(branch_id)

      if branch_id in pins do
        updated_bookmarks_pins = %BookmarkPin{
          bookmarks_pins
          | pins: List.delete(pins, branch_id)
        }

        BookmarksPins.update_bookmark_pin(bookmarks_pins, %{
          pins: updated_bookmarks_pins.pins
        })
      end

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(201, Jason.encode!("Pin Deleted"))
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!("User does not exist"))

    end
  end

  def remove_bookmark(conn, %{"user_id" => user_id, "file_id" => file_id}) do
    try do
      user_id = conn.assigns.current_user.id

      bookmarks_pins =
        case BookmarksPins.get_bookmarks_pins_by_userid(user_id) do
          nil ->
            new_bookmark = %BookmarkPin{
              userid: user_id,
              bookmarks: [],
              pins: []
            }
            {:ok, added_bookmark} = BookmarksPins.create_bookmark_pin(Map.from_struct(new_bookmark))
            added_bookmark
          existing_bp ->
            existing_bp
        end
      bookmarks = bookmarks_pins.bookmarks
      {file_id, ""} = Integer.parse(file_id)

      if file_id in bookmarks do
        updated_bookmarks_pins = %BookmarkPin{
          bookmarks_pins
          | bookmarks: List.delete(bookmarks, file_id)
        }

        BookmarksPins.update_bookmark_pin(bookmarks_pins, %{
          bookmarks: updated_bookmarks_pins.bookmarks
        })
      end

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(201, Jason.encode!("Bookmark Deleted"))
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!("User does not exist"))
    end
  end
end
