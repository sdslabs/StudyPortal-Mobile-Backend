defmodule StudyPortal.Repo.Migrations.CreateBranch do
  use Ecto.Migration

  def change do
    create table(:branches) do
      add :name, :string
      add :department, :string

      timestamps(type: :utc_datetime)
    end
  end
end
