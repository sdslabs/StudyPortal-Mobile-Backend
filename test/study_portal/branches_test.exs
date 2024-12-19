defmodule StudyPortal.BranchesTest do
  use StudyPortal.DataCase

  alias StudyPortal.Branches

  describe "branch" do
    alias StudyPortal.Branches.Branch

    import StudyPortal.BranchesFixtures

    @invalid_attrs %{name: nil, department: nil}

    test "list_branch/0 returns all branch" do
      branch = branch_fixture()
      assert Branches.list_branch() == [branch]
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert Branches.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      valid_attrs = %{name: "some name", department: "some department"}

      assert {:ok, %Branch{} = branch} = Branches.create_branch(valid_attrs)
      assert branch.name == "some name"
      assert branch.department == "some department"
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Branches.create_branch(@invalid_attrs)
    end

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      update_attrs = %{name: "some updated name", department: "some updated department"}

      assert {:ok, %Branch{} = branch} = Branches.update_branch(branch, update_attrs)
      assert branch.name == "some updated name"
      assert branch.department == "some updated department"
    end

    test "update_branch/2 with invalid data returns error changeset" do
      branch = branch_fixture()
      assert {:error, %Ecto.Changeset{}} = Branches.update_branch(branch, @invalid_attrs)
      assert branch == Branches.get_branch!(branch.id)
    end

    test "delete_branch/1 deletes the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{}} = Branches.delete_branch(branch)
      assert_raise Ecto.NoResultsError, fn -> Branches.get_branch!(branch.id) end
    end

    test "change_branch/1 returns a branch changeset" do
      branch = branch_fixture()
      assert %Ecto.Changeset{} = Branches.change_branch(branch)
    end
  end
end
