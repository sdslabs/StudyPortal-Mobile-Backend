defmodule StudyPortalWeb.BookmarkPinControllerTest do
  use StudyPortalWeb.ConnCase

  import StudyPortal.BookmarksPinsFixtures

  alias StudyPortal.BookmarksPins.BookmarkPin

  @create_attrs %{
    userid: 42,
    bookmarks: [1, 2],
    pins: [1, 2]
  }
  @update_attrs %{
    userid: 43,
    bookmarks: [1],
    pins: [1]
  }
  @invalid_attrs %{userid: nil, bookmarks: nil, pins: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bookmarks_pins", %{conn: conn} do
      conn = get(conn, ~p"/api/bookmarks_pins")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bookmark_pin" do
    test "renders bookmark_pin when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/bookmarks_pins", bookmark_pin: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/bookmarks_pins/#{id}")

      assert %{
               "id" => ^id,
               "bookmarks" => [1, 2],
               "pins" => [1, 2],
               "userid" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/bookmarks_pins", bookmark_pin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bookmark_pin" do
    setup [:create_bookmark_pin]

    test "renders bookmark_pin when data is valid", %{conn: conn, bookmark_pin: %BookmarkPin{id: id} = bookmark_pin} do
      conn = put(conn, ~p"/api/bookmarks_pins/#{bookmark_pin}", bookmark_pin: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/bookmarks_pins/#{id}")

      assert %{
               "id" => ^id,
               "bookmarks" => [1],
               "pins" => [1],
               "userid" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bookmark_pin: bookmark_pin} do
      conn = put(conn, ~p"/api/bookmarks_pins/#{bookmark_pin}", bookmark_pin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bookmark_pin" do
    setup [:create_bookmark_pin]

    test "deletes chosen bookmark_pin", %{conn: conn, bookmark_pin: bookmark_pin} do
      conn = delete(conn, ~p"/api/bookmarks_pins/#{bookmark_pin}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/bookmarks_pins/#{bookmark_pin}")
      end
    end
  end

  defp create_bookmark_pin(_) do
    bookmark_pin = bookmark_pin_fixture()
    %{bookmark_pin: bookmark_pin}
  end
end
