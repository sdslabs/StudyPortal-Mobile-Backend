defmodule StudyPortal.FilesTest do
  use StudyPortal.DataCase

  alias StudyPortal.Files

  describe "file_storages" do
    alias StudyPortal.Files.FileStorage

    import StudyPortal.FilesFixtures

    @invalid_attrs %{name: nil, status: nil, course_code: nil, s3_url: nil}

    test "list_file_storages/0 returns all file_storages" do
      file_storage = file_storage_fixture()
      assert Files.list_file_storages() == [file_storage]
    end

    test "get_file_storage!/1 returns the file_storage with given id" do
      file_storage = file_storage_fixture()
      assert Files.get_file_storage!(file_storage.id) == file_storage
    end

    test "create_file_storage/1 with valid data creates a file_storage" do
      valid_attrs = %{name: "some name", status: "some status", course_code: "some course_code", s3_url: "some s3_url"}

      assert {:ok, %FileStorage{} = file_storage} = Files.create_file_storage(valid_attrs)
      assert file_storage.name == "some name"
      assert file_storage.status == "some status"
      assert file_storage.course_code == "some course_code"
      assert file_storage.s3_url == "some s3_url"
    end

    test "create_file_storage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Files.create_file_storage(@invalid_attrs)
    end

    test "update_file_storage/2 with valid data updates the file_storage" do
      file_storage = file_storage_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", course_code: "some updated course_code", s3_url: "some updated s3_url"}

      assert {:ok, %FileStorage{} = file_storage} = Files.update_file_storage(file_storage, update_attrs)
      assert file_storage.name == "some updated name"
      assert file_storage.status == "some updated status"
      assert file_storage.course_code == "some updated course_code"
      assert file_storage.s3_url == "some updated s3_url"
    end

    test "update_file_storage/2 with invalid data returns error changeset" do
      file_storage = file_storage_fixture()
      assert {:error, %Ecto.Changeset{}} = Files.update_file_storage(file_storage, @invalid_attrs)
      assert file_storage == Files.get_file_storage!(file_storage.id)
    end

    test "delete_file_storage/1 deletes the file_storage" do
      file_storage = file_storage_fixture()
      assert {:ok, %FileStorage{}} = Files.delete_file_storage(file_storage)
      assert_raise Ecto.NoResultsError, fn -> Files.get_file_storage!(file_storage.id) end
    end

    test "change_file_storage/1 returns a file_storage changeset" do
      file_storage = file_storage_fixture()
      assert %Ecto.Changeset{} = Files.change_file_storage(file_storage)
    end
  end
end
