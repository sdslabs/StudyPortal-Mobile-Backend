defmodule StudyPortal.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :course_code, :string
      add :course_name, :string
      add :files, {:array, :integer}
      add :branch, references(:branches, on_delete: :nothing)
      add :semester, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:courses, [:course_code])
  end
end
