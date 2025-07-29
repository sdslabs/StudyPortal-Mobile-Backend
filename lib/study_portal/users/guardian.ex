defmodule StudyPortal.Users.Guardian do
  use Guardian, otp_app: :study_portal

  alias StudyPortal.Users.User

  def subject_for_token(user, _claims) do
    {:ok, "User:#{user.id}"}
  end

  # def subject_for_token(_type, _claims) do
  #   {:error, "Unknown resource type"}
  # end

  def resource_from_claims(claims) do
    case claims["sub"] do
      "User:" <> id -> {:ok, StudyPortal.Repo.get(User, id)}
      _ -> {:error, "Unknown resource type"}
    end
  end

end
