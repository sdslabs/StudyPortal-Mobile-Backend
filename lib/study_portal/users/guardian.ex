defmodule StudyPortal.Users.Guardian do
  use Guardian, otp_app: :study_portal

  alias StudyPortal.Users.User
  alias Guardian.DB

  def subject_for_token(user, _claims) do
    {:ok, "User:#{user.id}"}
  end

  # def subject_for_token(_type, _claims) do
  #   {:error, "Unknown resource type"}
  # end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end

  def resource_from_claims(claims) do
    case claims["sub"] do
      "User:" <> id -> {:ok, StudyPortal.Repo.get(User, id)}
      _ -> {:error, "Unknown resource type"}
    end
  end

end
