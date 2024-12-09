defmodule StudyPortal.Repo.Migrations.CreateFileStorages do
  use Ecto.Migration

  def change do
    create table(:file_storages) do
      add :name, :string
      add :course_code, :string
      add :s3_url, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
