defmodule StudyPortalWeb.Router do
  use StudyPortalWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/auth", StudyPortalWeb do
    pipe_through :api

    get "/ping", PingController, :index
    get "/google", GoogleAuthController, :index
    get "/google/callback", GoogleAuthController, :callback
    get "/logout", GoogleAuthController, :logout
  end

  pipeline :authenticated_api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug StudyPortalWeb.AuthPlug
  end

  scope "/api", StudyPortalWeb do
    pipe_through :authenticated_api

    get "/ping", PingController, :index
    get "/get-file/:id", FileStorageController, :give_get_url
    get "/course-mat/:course_code", CourseMaterialController, :index
    get "/pending-files", FileStorageController, :pending_files
    delete "/reject-file", FileStorageController, :delete
    patch "/accept-file/:id", FileStorageController, :update
    post "/upload-file", FileStorageController, :give_put_url
    patch "/upload-file-complete", FileStorageController, :upload_file_complete
    get "/branches", BranchController, :index
    get "/courses", CourseController, :index
    get "/pins", BookmarkPinController, :get_pins
    get "/bookmarks", BookmarkPinController, :get_bookmarks
    post "/add-pin", BookmarkPinController, :add_pin
    post "/add-bookmark", BookmarkPinController, :add_bookmark
    post "/remove-bookmark", BookmarkPinController, :remove_bookmark
    post "/remove-pin", BookmarkPinController, :remove_pin
    get "/user-info", UserController, :user_info
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
