defmodule StudyPortalWeb.CourseJSON do
  alias StudyPortal.Courses.Course

  @doc """
  Renders a list of courses.
  """
  def index(%{courses: courses}) do
    %{data: for(course <- courses, do: data(course))}
  end

  @doc """
  Renders a single course.
  """
  def show(%{course: course}) do
    %{data: data(course)}
  end

  defp data(%Course{} = course) do
    %{
      id: course.id,
      course_code: course.course_code,
      course_name: course.course_name,
      files: course.files,
      department: course.department
    }
  end
end
