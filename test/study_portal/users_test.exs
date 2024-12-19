defmodule StudyPortal.UsersTest do
  use StudyPortal.DataCase

  alias StudyPortal.Users

  describe "users" do
    alias StudyPortal.Users.User

    import StudyPortal.UsersFixtures

    @invalid_attrs %{name: nil, status: nil, enrollment_number: nil, course_code: nil, s3_url: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{name: "some name", status: "some status", enrollment_number: 42, course_code: "some course_code", s3_url: "some s3_url"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.status == "some status"
      assert user.enrollment_number == 42
      assert user.course_code == "some course_code"
      assert user.s3_url == "some s3_url"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", enrollment_number: 43, course_code: "some updated course_code", s3_url: "some updated s3_url"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.status == "some updated status"
      assert user.enrollment_number == 43
      assert user.course_code == "some updated course_code"
      assert user.s3_url == "some updated s3_url"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
