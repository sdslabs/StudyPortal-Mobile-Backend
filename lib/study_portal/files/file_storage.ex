defmodule StudyPortal.Files.FileStorage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "file_storages" do
    field :name, :string
    field :status, Ecto.Enum, values: [:pending, :approved, :rejected, :not_uploaded]
    field :course_id, :integer
    field :s3_url, :string
    field :type, Ecto.Enum, values: [:tutorial, :book, :pyq, :notes, :other]
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file_storage, attrs) do
    file_storage
    |> cast(attrs, [:name, :status, :course_id, :s3_url, :type, :description])
    |> validate_required([:name, :status, :course_id, :s3_url, :type, :description])
  end
end
