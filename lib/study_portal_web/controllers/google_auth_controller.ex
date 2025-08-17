defmodule StudyPortalWeb.GoogleAuthController do
  use StudyPortalWeb, :controller
  require Logger

  plug Ueberauth

  alias StudyPortal.Users
  alias StudyPortal.Users.User
  alias StudyPortal.Repo

  def index(conn, _params) do
    redirect(conn, to: "/auth/google")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    email = String.downcase(auth.info.email)

    if String.match?(email, ~r/@([a-z0-9\-]+\.)?iitr\.ac\.in$/) do
      user_params = %{
        google_id: auth.uid,
        email: email,
        name: auth.info.name,
        avatar: auth.info.image,
        token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token
      }

      case find_or_create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_session(:current_user_id, user.id)
          |> configure_session(renew: true)
          |> json(%{
            success: true,
            user: %{id: user.id, name: user.name, email: user.email}
          })

        {:error, changeset} ->
          errors =
            Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
              Enum.reduce(opts, msg, fn {key, value}, acc ->
                String.replace(acc, "%{#{key}}", to_string(value))
              end)
            end)

          conn
          |> put_status(401)
          |> json(%{
            success: false,
            error: "Could not create user",
            errors: errors
          })
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{success: false, error: "Only iitr.ac.in emails are allowed"})
    end
  end

  def callback(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{success: false, error: "Authentication failed"})
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/auth/google")
  end

  defp find_or_create_user(%{email: email} = user_params) do
    case Repo.get_by(User, email: email) do
      nil ->
        Users.create_user(user_params)

      existing_user ->
        Users.update_user(existing_user, user_params)
    end
  end
end
