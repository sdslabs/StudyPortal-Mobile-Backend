defmodule StudyPortal.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :course_code, :string
    field :course_name, :string
    field :files, :string
    field :department, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:course_code, :course_name, :files, :department])
    |> validate_required([:course_code, :course_name, :files, :department])
  end
end
