defmodule StudyPortal.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StudyPortal.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        course_code: "some course_code",
        enrollment_number: 42,
        name: "some name",
        s3_url: "some s3_url",
        status: "some status"
      })
      |> StudyPortal.Users.create_user()

    user
  end
end
