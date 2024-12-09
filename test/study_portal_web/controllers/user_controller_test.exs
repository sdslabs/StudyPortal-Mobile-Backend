defmodule StudyPortalWeb.UserControllerTest do
  use StudyPortalWeb.ConnCase

  import StudyPortal.UsersFixtures

  alias StudyPortal.Users.User

  @create_attrs %{
    name: "some name",
    status: "some status",
    enrollment_number: 42,
    course_code: "some course_code",
    s3_url: "some s3_url"
  }
  @update_attrs %{
    name: "some updated name",
    status: "some updated status",
    enrollment_number: 43,
    course_code: "some updated course_code",
    s3_url: "some updated s3_url"
  }
  @invalid_attrs %{name: nil, status: nil, enrollment_number: nil, course_code: nil, s3_url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "course_code" => "some course_code",
               "enrollment_number" => 42,
               "name" => "some name",
               "s3_url" => "some s3_url",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "course_code" => "some updated course_code",
               "enrollment_number" => 43,
               "name" => "some updated name",
               "s3_url" => "some updated s3_url",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
