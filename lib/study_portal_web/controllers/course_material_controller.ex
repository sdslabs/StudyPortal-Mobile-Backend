defmodule StudyPortalWeb.CourseMaterialController do
  use StudyPortalWeb, :controller
  alias StudyPortal.Content

  @doc """
  Fetches and returns course materials for a given course code.
  """
  def index(conn, %{"course_code" => course_code}) do
    case Content.get_course_material_by_code(course_code) do
      [] ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No course materials found for course: #{course_code}"})

      materials ->
        conn
        |> put_status(:ok)
        |> json(%{data: materials})
    end
  end
end
