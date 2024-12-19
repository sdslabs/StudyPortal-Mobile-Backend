defmodule StudyPortal.BookmarksPinsTest do
  use StudyPortal.DataCase

  alias StudyPortal.BookmarksPins

  describe "bookmarks_pins" do
    alias StudyPortal.BookmarksPins.BookmarkPin

    import StudyPortal.BookmarksPinsFixtures

    @invalid_attrs %{userid: nil, bookmarks: nil, pins: nil}

    test "list_bookmarks_pins/0 returns all bookmarks_pins" do
      bookmark_pin = bookmark_pin_fixture()
      assert BookmarksPins.list_bookmarks_pins() == [bookmark_pin]
    end

    test "get_bookmark_pin!/1 returns the bookmark_pin with given id" do
      bookmark_pin = bookmark_pin_fixture()
      assert BookmarksPins.get_bookmark_pin!(bookmark_pin.id) == bookmark_pin
    end

    test "create_bookmark_pin/1 with valid data creates a bookmark_pin" do
      valid_attrs = %{userid: 42, bookmarks: [1, 2], pins: [1, 2]}

      assert {:ok, %BookmarkPin{} = bookmark_pin} = BookmarksPins.create_bookmark_pin(valid_attrs)
      assert bookmark_pin.userid == 42
      assert bookmark_pin.bookmarks == [1, 2]
      assert bookmark_pin.pins == [1, 2]
    end

    test "create_bookmark_pin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookmarksPins.create_bookmark_pin(@invalid_attrs)
    end

    test "update_bookmark_pin/2 with valid data updates the bookmark_pin" do
      bookmark_pin = bookmark_pin_fixture()
      update_attrs = %{userid: 43, bookmarks: [1], pins: [1]}

      assert {:ok, %BookmarkPin{} = bookmark_pin} = BookmarksPins.update_bookmark_pin(bookmark_pin, update_attrs)
      assert bookmark_pin.userid == 43
      assert bookmark_pin.bookmarks == [1]
      assert bookmark_pin.pins == [1]
    end

    test "update_bookmark_pin/2 with invalid data returns error changeset" do
      bookmark_pin = bookmark_pin_fixture()
      assert {:error, %Ecto.Changeset{}} = BookmarksPins.update_bookmark_pin(bookmark_pin, @invalid_attrs)
      assert bookmark_pin == BookmarksPins.get_bookmark_pin!(bookmark_pin.id)
    end

    test "delete_bookmark_pin/1 deletes the bookmark_pin" do
      bookmark_pin = bookmark_pin_fixture()
      assert {:ok, %BookmarkPin{}} = BookmarksPins.delete_bookmark_pin(bookmark_pin)
      assert_raise Ecto.NoResultsError, fn -> BookmarksPins.get_bookmark_pin!(bookmark_pin.id) end
    end

    test "change_bookmark_pin/1 returns a bookmark_pin changeset" do
      bookmark_pin = bookmark_pin_fixture()
      assert %Ecto.Changeset{} = BookmarksPins.change_bookmark_pin(bookmark_pin)
    end
  end
end
