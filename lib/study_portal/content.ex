defmodule StudyPortal.Content do
  import Ecto.Query
  alias StudyPortal.Repo
  alias StudyPortal.Files.FileStorage
  alias StudyPortal.Courses.Course

  @doc """
  Fetches all course material (files) for a given course name.
  """
  def get_course_material_by_code(course_code) do
    query =
      from fs in FileStorage,
        join: c in Course,
        on: c.id == fs.course_id,
        where: c.course_code == ^course_code,
        select: %{
          file_id: fs.id,
          file_name: fs.name,
          file_description: fs.description,
          file_type: fs.type,
          file_s3_url: fs.s3_url,
          course_code: c.course_code,
          inserted_at: fs.inserted_at,
          file_status: fs.status
        }

    Repo.all(query)
  end
end
