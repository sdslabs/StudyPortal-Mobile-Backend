defmodule StudyPortalWeb.PingController do
  use StudyPortalWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "pong"})
  end
end
