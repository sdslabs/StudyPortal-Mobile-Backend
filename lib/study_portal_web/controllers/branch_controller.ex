defmodule StudyPortalWeb.BranchController do
  use StudyPortalWeb, :controller

  alias StudyPortal.Branches
  alias StudyPortal.Branches.Branch

  action_fallback StudyPortalWeb.FallbackController

  def index(conn, _params) do
    branch = Branches.list_branch()
    render(conn, :index, branch: branch)
  end

  def create(conn, %{"branch" => branch_params}) do
    with {:ok, %Branch{} = branch} <- Branches.create_branch(branch_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/branch/#{branch}")
      |> render(:show, branch: branch)
    end
  end

  def show(conn, %{"id" => id}) do
    branch = Branches.get_branch!(id)
    render(conn, :show, branch: branch)
  end

  def update(conn, %{"id" => id, "branch" => branch_params}) do
    branch = Branches.get_branch!(id)

    with {:ok, %Branch{} = branch} <- Branches.update_branch(branch, branch_params) do
      render(conn, :show, branch: branch)
    end
  end

  def delete(conn, %{"id" => id}) do
    branch = Branches.get_branch!(id)

    with {:ok, %Branch{}} <- Branches.delete_branch(branch) do
      send_resp(conn, :no_content, "")
    end
  end
end
