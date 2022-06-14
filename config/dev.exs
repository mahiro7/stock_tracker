import Config

config :stock_tracker, port: 8080

config :stock_tracker, :alpha_vantage,
  http_client: HTTPoison,
  api_url: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&interval=5min&apikey=" <> "A88PQON59FAHSZEQ" <> "&symbol="
