defmodule StudyPortal.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :course_code, :string
      add :course_name, :string
      add :files, :string
      add :department, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
