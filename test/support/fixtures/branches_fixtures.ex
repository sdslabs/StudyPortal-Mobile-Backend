defmodule StudyPortal.BranchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StudyPortal.Branches` context.
  """

  @doc """
  Generate a branch.
  """
  def branch_fixture(attrs \\ %{}) do
    {:ok, branch} =
      attrs
      |> Enum.into(%{
        department: "some department",
        name: "some name"
      })
      |> StudyPortal.Branches.create_branch()

    branch
  end
end
