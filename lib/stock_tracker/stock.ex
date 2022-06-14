defmodule StockTracker.Stock do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias StockTracker.{Stock, Ticker, Repo}

  schema "stocks" do
    field :date, :naive_datetime
    field :open, :float
    field :high, :float
    field :low, :float
    field :close, :float
    field :volume, :integer
    belongs_to :ticker, StockTracker.Ticker
  end

  def create_assoc(stock, ticker) do
    new_ticker = ticker
    |> Repo.preload(:stocks)

    new_ticker
    |> change()
    |> put_assoc(:stocks, new_ticker.stocks ++ stock |> Enum.uniq_by(&({&1.date})))
    |> Repo.update!()
  end

  def format_response(response) do
    response
    |> Enum.map(&format_response_pattern/1)
  end

  defp format_response_pattern(response) do
    %{
      date: NaiveDateTime.to_string(response.date),
      open: response.open,
      high: response.high,
      low: response.low,
      close: response.close,
      volume: response.volume
    }
    #|> Jason.encode!()
  end

  def list(ticker, filter) do
    ticker = Ticker.get_by_symbol(ticker)

    ticker.id
    |> list_query(filter)
    |> IO.inspect
    |> Repo.all()
    |> format_response()
  end

  def list_query(ticker_id, filter) do
    conditions = dynamic([s], s.ticker_id == ^ticker_id)

    conditions =
      if filter["start"] do
        dynamic([s], s.date >= ^filter["start"] and ^conditions)
      else
        conditions
      end

    conditions =
      if filter["end"] do
        dynamic([s], s.date <= ^filter["end"] and ^conditions)
      else
        conditions
      end

    conditions =
      if filter["min_volume"] do
        dynamic([s], s.volume >= ^filter["min_volume"] and ^conditions)
      else
        conditions
      end

    conditions =
      if filter["max_volume"] do
        dynamic([s], s.volume <= ^filter["max_volume"] and ^conditions)
      else
        conditions
      end

    from s in Stock,
      where: ^conditions,
      order_by: [desc: s.date],
      select: s
  end

  def format(stock) do
    stock
    |> Enum.map(&format_stock_pattern/1)
  end

  defp format_stock_pattern({date, %{"1. open" => open, "2. high" => high, "3. low" => low, "4. close" => close, "5. volume" => volume}}) do
    %{date: NaiveDateTime.from_iso8601!(date), open: String.to_float(open), high: String.to_float(high), low: String.to_float(low), close: String.to_float(close), volume: String.to_integer(volume)}
  end

end
