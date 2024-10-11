defmodule StudyPortal.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table("users") do
      add :arcusid, :integer
      add :name, :string, size: 255
      add :enrollment, :integer
    end
  end
end
