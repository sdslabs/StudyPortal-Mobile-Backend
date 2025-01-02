defmodule StudyPortalWeb.Router do
  use StudyPortalWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline,
      module: StudyPortal.Users.Guardian,
      error_handler: StudyPortal.Users.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
    plug Guardian.Plug.LoadResource, allow_blank: "false"
  end

  pipeline :admincheck do
    plug :ensure_admin

    defp ensure_admin(conn, _opts) do
      current_user = Guardian.Plug.current_resource(conn)

      if current_user && current_user.is_admin do
        conn
      else
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Not authorized"})
        |> halt()
      end
    end
  end

  scope "/api", StudyPortalWeb do
    pipe_through :api
    # no-auth
    get "/ping", PingController, :index
    post "/register", AuthController, :register
    post "/login", AuthController, :login
  end

  scope "/api", StudyPortalWeb do
    pipe_through [:api, :auth, :admincheck]

    # admin
    delete "/reject-file", FileStorageController, :delete
    patch "/approve-file", FileStorageController, :update
    get "/pending-files", FileStorageController, :pending_files
  end

  scope "/api", StudyPortalWeb do
    pipe_through [:api, :auth]

    get "/protected", AuthController, :protected
    post "/logout", AuthController, :logout
    # user
    get "/get-file/:id", FileStorageController, :give_get_url
    get "/course-mat/:course_code", CourseMaterialController, :index
    post "/upload-file", FileStorageController, :give_put_url
    patch "/upload-file-complete", FileStorageController, :upload_file_complete
    get "/branches", BranchController, :index
    get "/courses", CourseController, :index
    get "/pins", BookmarkPinController, :get_pins
    get "/bookmarks", BookmarkPinController, :get_bookmarks
    post "/add-pin", BookmarkPinController, :add_pin
    post "/add-bookmark", BookmarkPinController, :add_bookmark
    delete "/remove-bookmark", BookmarkPinController, :remove_bookmark
    delete "/remove-pin", BookmarkPinController, :remove_pin
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
