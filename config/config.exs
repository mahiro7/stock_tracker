import Config


config :stock_tracker, StockTracker.Repo,
  url: System.get_env("DATABASE_URL"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10


config :stock_tracker, ecto_repos: [StockTracker.Repo]

# End
import_config("#{config_env()}.exs")
