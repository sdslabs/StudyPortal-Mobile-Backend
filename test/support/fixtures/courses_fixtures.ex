defmodule StudyPortal.CoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StudyPortal.Courses` context.
  """

  @doc """
  Generate a course.
  """
  def course_fixture(attrs \\ %{}) do
    {:ok, course} =
      attrs
      |> Enum.into(%{
        course_code: "some course_code",
        course_name: "some course_name",
        department: "some department",
        files: "some files"
      })
      |> StudyPortal.Courses.create_course()

    course
  end
end
