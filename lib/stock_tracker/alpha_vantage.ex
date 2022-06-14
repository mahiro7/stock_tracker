defmodule StockTracker.AlphaVantage do
  @moduledoc """
    Module with functions to use the API to get stocks
  """

  alias StockTracker.{Ticker, Stock}

  def get_stock(ticker, params \\ %{}) do
    stocks = Stock.list(ticker, params)

    {:ok, stocks}
  end

  def update_stock(symbol, ticker) do
    with {:ok, stock} <- stock_request(symbol) do
      stock.time_series
      |> Stock.format()
      |> Stock.create_assoc(ticker)
    end
  end

  def new_stock(ticker) do
    with {:ok, stock} <- stock_request(ticker),
    false <- has_ticker?(ticker) do
      case Ticker.create(ticker) do
        {:ok, created_ticker} ->
          create_scheduler(created_ticker, stock, true)
          {:ok}
        _ ->
          {:error, "Error creating ticker"}
      end
    else
      true ->
        {:error, "Ticker already tracked"}
      err ->
        err
    end
  end

  defp has_ticker?(ticker), do: Ticker.has_ticker?(ticker)

  def stock_request(ticker, config \\ default_config()) do
    ticker
    |> format_ticker()
    |> request(config)
  end

  defp request(ticker, config) do
    url = Keyword.get(config, :api_url, "") <> ticker
    http_client = Keyword.get(config, :http_client)

    url
    |> http_client.get()
    |> handle_request()
  end


  defp handle_request({:ok, %HTTPoison.Response{body: body, status_code: 200}}), do: format_stock(body)
  defp handle_request(_), do: {:error, "Error on request"}

  def format_ticker(ticker), do: String.replace(ticker, "$", "") |> String.upcase()

  defp format_stock(stock) do
    case Jason.decode(stock) do
      {:ok, %{"Meta Data" => %{"3. Last Refreshed" => last_refreshed}, "Time Series (5min)" => time_series}} ->
        {:ok, %{last_refreshed: last_refreshed, time_series: time_series}}
      {:ok, %{"Error Message" => _error_message}} ->
        {:error, "Invalid ticker"}
      _ ->
        {:error, "Error trying to decode API response"}
    end
  end

  defp create_scheduler(ticker, stock, _first_stock) do
    stock.time_series
    |> Stock.format()
    |> Stock.create_assoc(ticker)

    Kernel.send(StockTracker.RequestScheduler, {:work, ticker})
  end

  defp default_config(), do: Application.get_env(:stock_tracker, :alpha_vantage)
end
