defmodule StudyPortalWeb.BranchControllerTest do
  use StudyPortalWeb.ConnCase

  import StudyPortal.BranchesFixtures

  alias StudyPortal.Branches.Branch

  @create_attrs %{
    name: "some name",
    department: "some department"
  }
  @update_attrs %{
    name: "some updated name",
    department: "some updated department"
  }
  @invalid_attrs %{name: nil, department: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all branch", %{conn: conn} do
      conn = get(conn, ~p"/api/branch")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create branch" do
    test "renders branch when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/branch", branch: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/branch/#{id}")

      assert %{
               "id" => ^id,
               "department" => "some department",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/branch", branch: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update branch" do
    setup [:create_branch]

    test "renders branch when data is valid", %{conn: conn, branch: %Branch{id: id} = branch} do
      conn = put(conn, ~p"/api/branch/#{branch}", branch: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/branch/#{id}")

      assert %{
               "id" => ^id,
               "department" => "some updated department",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, branch: branch} do
      conn = put(conn, ~p"/api/branch/#{branch}", branch: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete branch" do
    setup [:create_branch]

    test "deletes chosen branch", %{conn: conn, branch: branch} do
      conn = delete(conn, ~p"/api/branch/#{branch}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/branch/#{branch}")
      end
    end
  end

  defp create_branch(_) do
    branch = branch_fixture()
    %{branch: branch}
  end
end
