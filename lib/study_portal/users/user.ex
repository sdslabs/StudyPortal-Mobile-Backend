defmodule StudyPortal.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :enrollment_number, :string
    field :name, :string
    field :arcus_id, :string
    field :hash, :string
    field :salt, :string
    field :email, :string
    field :google_id, :string
    field :avatar, :string
    field :token, :string
    field :refresh_token, :string
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :google_id, :avatar, :token, :refresh_token])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:google_id)
  end
end
