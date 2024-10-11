defmodule StudyPortal.Repo do
  use Ecto.Repo,
    otp_app: :study_portal,
    adapter: Ecto.Adapters.Postgres
end
