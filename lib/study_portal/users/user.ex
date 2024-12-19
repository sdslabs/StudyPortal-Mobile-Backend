defmodule StudyPortal.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :enrollment_number, :integer
    field :arcus_id, :integer
    field :hash, :string
    field :salt, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :enrollment_number, :arcus_id, :hash, :salt])
    |> validate_required([:name, :enrollment_number, :arcus_id, :hash, :salt])
  end
end
