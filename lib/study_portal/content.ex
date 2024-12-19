defmodule StudyPortal.Content do
  import Ecto.Query
  alias StudyPortal.Repo
  alias StudyPortal.Files.FileStorage
  alias StudyPortal.Courses.Course

  @doc """
  Fetches all course material (files) for a given course name.
  """
  def get_course_material_by_name(course_name) do
    query =
      from fs in FileStorage,
        join: c in Course,
        on: c.id == fs.course_id,
        where: c.course_name == ^course_name,
        where: fs.status == :approved,
        select: %{
          file_name: fs.name,
          file_description: fs.description,
          file_type: fs.type,
          file_status: fs.status,
          file_s3_url: fs.s3_url,
          course_name: c.course_name,
          inserted_at: fs.inserted_at
        }

    Repo.all(query)
  end
end
