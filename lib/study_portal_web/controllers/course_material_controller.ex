defmodule StudyPortalWeb.CourseMaterialController do
  use StudyPortalWeb, :controller

  alias StudyPortal.Content

  @doc """
  Fetches and returns course materials for a given course name.
  """
  def index(conn, %{"course_name" => course_name}) do
    case Content.get_course_material_by_name(course_name) do
      [] ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No course materials found for course: #{course_name}"})

      materials ->
        conn
        |> put_status(:ok)
        |> json(%{data: materials})
    end
  end
end
