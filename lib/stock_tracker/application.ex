defmodule StockTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: StockTracker.Worker.start_link(arg)
      # {StockTracker.Worker, arg}
      StockTracker.Repo,
      {Plug.Cowboy,
       scheme: :http,
       plug: StockTracker.Router,
       options: [port: Application.get_env(:stock_tracker, :port)]},
       StockTracker.RequestScheduler
    ]

    Logger.info("StockTracker started on port: #{Application.get_env(:stock_tracker, :port)}")
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StockTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
