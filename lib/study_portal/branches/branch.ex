defmodule StudyPortal.Branches.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "branches" do
    field :name, :string
    field :department, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:name, :department])
    |> validate_required([:name, :department])
  end
end
