defmodule StudyPortal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StudyPortalWeb.Telemetry,
      StudyPortal.Repo,
      {DNSCluster, query: Application.get_env(:study_portal, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: StudyPortal.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: StudyPortal.Finch},
      # Start a worker by calling: StudyPortal.Worker.start_link(arg)
      # {StudyPortal.Worker, arg},
      # Start to serve requests, typically the last entry
      StudyPortalWeb.Endpoint,
      {Guardian.DB.Token.SweeperServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StudyPortal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StudyPortalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
