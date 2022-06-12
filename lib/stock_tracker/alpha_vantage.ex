defmodule StockTracker.AlphaVantage do
  @moduledoc """
    Module with functions to use the API to get stocks
  """

  def get_stock(ticker) do
    # ticker |> format_ticker |> Verifies if exists on database
    #                            if not -> Time Series returns the first price only!
    #                            else -> Returns and save last 100 occurrences every 475 minutes
    # |> Httpoison |> format_stock (returns map)
  end

  defp format_ticker(ticker), do: String.upcase(ticker)

  defp format_stock(_stock) do
    {_, stock} = File.read("./query.json")

    case Jason.decode(stock) do
      {:ok, %{"Meta Data" => %{"3. Last Refreshed" => last_refreshed}, "Time Series (5min)" => time_series}} ->
        {:ok, %{last_refreshed: last_refreshed, time_series: time_series}}
      _ ->
        {:err, %{message: "Error trying to decode API response"}}
    end

    defp save_stock() do
      # DataBase: stock_tracker
      # Table: Stocks
      # Columns: Ticker | ???
      # Table: time_series
      # Columns: Stock (foreign key) | Information -> One to Many
      # Árvore binária para realizar a iteração entre os time_series |> Deve ser possível comparar os timestamps
      #                                                                 "YYYY-MM-DD HH:MM:SS"
    end
  end


end
