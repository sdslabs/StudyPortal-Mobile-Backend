defmodule StudyPortalWeb.PingController do
  use StudyPortalWeb, :controller

  def index(conn, _params) do
    user = conn.assigns.current_user
    IO.inspect(user, label: "Current User")
    json(conn, %{message: "pong"})
  end
end
