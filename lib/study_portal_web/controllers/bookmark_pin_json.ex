defmodule StudyPortalWeb.BookmarkPinJSON do
  alias StudyPortal.BookmarksPins.BookmarkPin
  alias StudyPortal.Branches.Branch
  alias StudyPortal.Files.FileStorage

  @doc """
  Renders a list of bookmarks_pins.
  """
  def index(%{bookmarks_pins: bookmarks_pins}) do
    %{data: for(bookmark_pin <- bookmarks_pins, do: data(bookmark_pin))}
  end

  @doc """
  Renders a single bookmark_pin.
  """
  def show(%{bookmark_pin: bookmark_pin}) do
    %{data: data(bookmark_pin)}
  end

  defp data(%BookmarkPin{} = bookmark_pin) do
    %{
      id: bookmark_pin.id,
      userid: bookmark_pin.userid,
      bookmarks: bookmark_pin.bookmarks,
      pins: bookmark_pin.pins
    }
  end

  def branches(%{bookmark_pin: bookmark_pin}) do
    %{data: Enum.map(bookmark_pin, fn x -> branch_data(StudyPortal.Branches.get_branch!(x)) end)}
  end

  defp branch_data(%Branch{} = branch) do
    %{
      id: branch.id,
      name: branch.name,
      department: branch.department
    }
  end

  def files(%{bookmark_pin: bookmark_pin}) do
    %{data: Enum.map(bookmark_pin, fn x -> file_data(StudyPortal.Files.get_file_storage!(x)) end)}
  end

  defp file_data(%FileStorage{} = file_storage) do
    %{
      id: file_storage.id,
      name: file_storage.name,
      course_id: file_storage.course_id,
      s3_url: file_storage.s3_url,
      status: file_storage.status,
      description: file_storage.description,
      type: file_storage.type
    }
  end
end
