defmodule StudyPortal.FilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StudyPortal.Files` context.
  """

  @doc """
  Generate a file_storage.
  """
  def file_storage_fixture(attrs \\ %{}) do
    {:ok, file_storage} =
      attrs
      |> Enum.into(%{
        course_code: "some course_code",
        name: "some name",
        s3_url: "some s3_url",
        status: "some status"
      })
      |> StudyPortal.Files.create_file_storage()

    file_storage
  end
end
