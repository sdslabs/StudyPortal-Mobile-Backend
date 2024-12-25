defmodule StudyPortalWeb.Router do
  use StudyPortalWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StudyPortalWeb do
    pipe_through :api

    get "/ping", PingController, :index
    get "/course-mat/:id", FileStorageController, :give_get_url
    get "/pending-files", FileStorageController, :pending_files
    delete "/reject-file", FileStorageController, :delete
    patch "/accept-file/:id", FileStorageController, :update
    post "/upload-file", FileStorageController, :give_put_url
    patch "/upload-file-complete", FileStorageController, :complete_upload
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:study_portal, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: StudyPortalWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
