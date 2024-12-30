defmodule StudyPortalWeb.CourseController do
  use StudyPortalWeb, :controller

  alias StudyPortal.Courses
  alias StudyPortal.Courses.Course

  action_fallback StudyPortalWeb.FallbackController

  def index(conn, %{"branch_id" => branch_id}) do
    courses = Courses.get_courses_by_branch(branch_id)
    render(conn, :index, courses: courses)
  end

  def create(conn, %{"course" => course_params}) do
    with {:ok, %Course{} = course} <- Courses.create_course(course_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/courses/#{course}")
      |> render(:show, course: course)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    render(conn, :show, course: course)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Courses.get_course!(id)

    with {:ok, %Course{} = course} <- Courses.update_course(course, course_params) do
      render(conn, :show, course: course)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Courses.get_course!(id)

    with {:ok, %Course{}} <- Courses.delete_course(course) do
      send_resp(conn, :no_content, "")
    end
  end
end
