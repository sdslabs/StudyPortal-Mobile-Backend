defmodule StudyPortalWeb.FileStorageControllerTest do
  use StudyPortalWeb.ConnCase

  import StudyPortal.FilesFixtures

  alias StudyPortal.Files.FileStorage

  @create_attrs %{
    name: "some name",
    status: "some status",
    course_code: "some course_code",
    s3_url: "some s3_url"
  }
  @update_attrs %{
    name: "some updated name",
    status: "some updated status",
    course_code: "some updated course_code",
    s3_url: "some updated s3_url"
  }
  @invalid_attrs %{name: nil, status: nil, course_code: nil, s3_url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all file_storages", %{conn: conn} do
      conn = get(conn, ~p"/api/file_storages")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create file_storage" do
    test "renders file_storage when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/file_storages", file_storage: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/file_storages/#{id}")

      assert %{
               "id" => ^id,
               "course_code" => "some course_code",
               "name" => "some name",
               "s3_url" => "some s3_url",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/file_storages", file_storage: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update file_storage" do
    setup [:create_file_storage]

    test "renders file_storage when data is valid", %{conn: conn, file_storage: %FileStorage{id: id} = file_storage} do
      conn = put(conn, ~p"/api/file_storages/#{file_storage}", file_storage: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/file_storages/#{id}")

      assert %{
               "id" => ^id,
               "course_code" => "some updated course_code",
               "name" => "some updated name",
               "s3_url" => "some updated s3_url",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, file_storage: file_storage} do
      conn = put(conn, ~p"/api/file_storages/#{file_storage}", file_storage: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete file_storage" do
    setup [:create_file_storage]

    test "deletes chosen file_storage", %{conn: conn, file_storage: file_storage} do
      conn = delete(conn, ~p"/api/file_storages/#{file_storage}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/file_storages/#{file_storage}")
      end
    end
  end

  defp create_file_storage(_) do
    file_storage = file_storage_fixture()
    %{file_storage: file_storage}
  end
end
