defmodule StudyPortal.Repo.Migrations.CreateBookmarksPins do
  use Ecto.Migration

  def change do
    create table(:bookmarks_pins) do
      add :userid, references(:user, on_delete: :nothing)
      add :bookmarks, {:array, :integer}
      add :pins, {:array, :integer}

      timestamps(type: :utc_datetime)
    end
  end
end
