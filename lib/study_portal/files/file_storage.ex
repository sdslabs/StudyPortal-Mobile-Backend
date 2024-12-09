defmodule StudyPortal.Files.FileStorage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "file_storages" do
    field :name, :string
    field :status, :string
    field :course_code, {:array, :string}
    field :s3_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file_storage, attrs) do
    file_storage
    |> cast(attrs, [:name, :course_code, :s3_url, :status])
    |> validate_required([:name, :course_code, :s3_url, :status])
  end
end
