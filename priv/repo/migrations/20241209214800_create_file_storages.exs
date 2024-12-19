defmodule StudyPortal.Repo.Migrations.CreateFileStorages do
  use Ecto.Migration
  # use StudyPortal.Repo.Migrations.CreateCourses

  def change do
    create table(:file_storages) do
      add :name, :string
      add :description, :string
      add :type, :string
      add :course_id, references(:courses, on_delete: :nothing)
      add :s3_url, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:file_storages, [:name])
  end
end
