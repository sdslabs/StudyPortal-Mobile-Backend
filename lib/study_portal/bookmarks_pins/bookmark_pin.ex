defmodule StudyPortal.BookmarksPins.BookmarkPin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookmarks_pins" do
    field :userid, :integer
    field :bookmarks, {:array, :integer}
    field :pins, {:array, :integer}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bookmark_pin, attrs) do
    bookmark_pin
    |> cast(attrs, [:userid, :bookmarks, :pins])
    |> validate_required([:userid, :bookmarks, :pins])
  end
end
