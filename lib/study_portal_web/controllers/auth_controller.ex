defmodule StudyPortalWeb.AuthController do
  use StudyPortalWeb, :controller

  alias StudyPortal.Users
  alias StudyPortal.Users.Guardian

  def register(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> put_resp_cookie("token", token, http_only: true, secure: true)
        |> json(%{message: "User created successfully"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_changeset_errors(changeset)})
    end
  end

  def login(conn, %{"enrollment_number" => enrollment_number, "password" => password}) do
    case Users.authenticate_user(enrollment_number, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> put_resp_cookie("token", token, http_only: true, secure: true)
        |> json(%{message: "Successfully logged in"})

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def logout(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    Guardian.revoke(jwt)

    conn
    |> json(%{message: "Successfully logged out"})
  end

  def protected(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> json(%{message: "This is a protected route", user_enrollment_number: user.enrollment_number})
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
