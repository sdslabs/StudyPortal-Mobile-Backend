defmodule StudyPortal.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :course_code, :string
    field :course_name, :string
    field :files, {:array, :integer}
    field :branch, :integer
    field :semester, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:course_code, :course_name, :files, :branch, :semester])
    |> validate_required([:course_code, :course_name, :files, :branch, :semester])
    |> unique_constraint(:course_code)
  end
end
