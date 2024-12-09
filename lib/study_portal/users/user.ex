defmodule StudyPortal.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :status, :string
    field :enrollment_number, :integer
    field :course_code, :string
    field :s3_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:enrollment_number, :name, :course_code, :s3_url, :status])
    |> validate_required([:enrollment_number, :name, :course_code, :s3_url, :status])
  end
end
