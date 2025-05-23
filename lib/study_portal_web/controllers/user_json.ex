defmodule StudyPortalWeb.UserJSON do
  alias StudyPortal.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      enrollment_number: user.enrollment_number,
      name: user.name,
      arcus_id: user.arcus_id,
      hash: user.hash,
      salt: user.salt
    }
  end
end
