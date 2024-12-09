defmodule StudyPortal.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :enrollment_number, :integer
      add :name, :string
      add :course_code, :string
      add :s3_url, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
