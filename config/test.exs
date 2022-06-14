import Config

config :stock_tracker, port: 8081

config :stock_tracker, :alpha_vantage,
  http_client: HTTPoison.BaseMock,
  api_url: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&interval=5min&apikey=" <> "A88PQON59FAHSZEQ" <> "&symbol=",

  mock_error_response: %{
    "Error Message" => "Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_INTRADAY."
  },

  mock_success_response: %{
    "Meta Data" => %{
        "1. Information" => "Intraday (5min) open, high, low, close prices and volume",
        "2. Symbol" => "IBM",
        "3. Last Refreshed" => "2022-06-09 19:55:00",
        "4. Interval" => "5min",
        "5. Output Size" => "Compact",
        "6. Time Zone" => "US/Eastern"
    },
    "Time Series (5min)" => %{
        "2022-06-09 19:55:00" => %{
            "1. open" => "137.9600",
            "2. high" => "137.9600",
            "3. low" => "137.9600",
            "4. close" => "137.9600",
            "5. volume" => "300"
        },
        "2022-06-09 19:15:00" => %{
            "1. open" => "138.0200",
            "2. high" => "138.0200",
            "3. low" => "138.0000",
            "4. close" => "138.0000",
            "5. volume" => "515"
        },
        "2022-06-09 18:35:00" => %{
            "1. open" => "138.2300",
            "2. high" => "138.2300",
            "3. low" => "138.2300",
            "4. close" => "138.2300",
            "5. volume" => "250"
        }
      }
  }
