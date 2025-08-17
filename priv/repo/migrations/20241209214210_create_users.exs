defmodule StudyPortal.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :enrollment_number, :integer
      add :name, :string
      add :arcus_id, :integer
      add :hash, :string
      add :salt, :string

      timestamps(type: :utc_datetime)
    end
  end
end
