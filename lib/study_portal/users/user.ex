defmodule StudyPortal.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :enrollment_number, :integer
    field :arcus_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :enrollment_number, :arcus_id])
    |> validate_required([:name, :enrollment_number, :arcus_id])
  end
end
