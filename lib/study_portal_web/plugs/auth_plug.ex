defmodule StudyPortalWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias StudyPortal.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_current_user(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Authentication required"})
        |> halt()
      user ->
        assign(conn, :current_user, user)
    end
  end

  def authenticate_user(conn, _opts) do
    case get_current_user(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Authentication required"})
        |> halt()
      user ->
        assign(conn, :current_user, user)
    end
  end

  defp get_current_user(conn) do
    user_id = get_session(conn, :current_user_id)
    if user_id, do: Users.get_user!(user_id), else: nil
  end
end
