defmodule StudyPortal.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :enrollment_number, :string
      add :name, :string
      add :arcus_id, :string
      add :password_hash, :string
      add :is_admin, :boolean, default: false
      add :password, :string, virtual: true

      timestamps(type: :utc_datetime)
    end
  end
end
