import Config


config :stock_tracker, StockTracker.Repo,
  database: "stock_tracker",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"


config :stock_tracker, ecto_repos: [StockTracker.Repo]

# End
import_config("#{config_env()}.exs")
