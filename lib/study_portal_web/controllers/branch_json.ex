defmodule StudyPortalWeb.BranchJSON do
  alias StudyPortal.Branches.Branch

  @doc """
  Renders a list of branch.
  """
  def index(%{branch: branch}) do
    %{data: for(branch <- branch, do: data(branch))}
  end

  @doc """
  Renders a single branch.
  """
  def show(%{branch: branch}) do
    %{data: data(branch)}
  end

  defp data(%Branch{} = branch) do
    %{
      id: branch.id,
      name: branch.name,
      department: branch.department
    }
  end
end
