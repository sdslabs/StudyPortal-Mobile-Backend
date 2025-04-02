defmodule StudyPortal.Repo.Migrations.AddGoogleAuthToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # Keeping enrollment_number and arcus_id as integers
      add :email, :string
      add :google_id, :string
      add :avatar, :string
      add :token, :text
      add :refresh_token, :text

    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:google_id])
  end
end
