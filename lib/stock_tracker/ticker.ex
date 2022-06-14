defmodule StockTracker.Ticker do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias StockTracker.{Ticker, Repo}

  schema "tickers" do
    field :symbol, :string
    has_many :stocks, StockTracker.Stock
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:symbol])
  end

  def create(ticker) do
    Ticker.changeset(%Ticker{}, %{symbol: ticker})
    |> Repo.insert()
  end

  def get_by_symbol(ticker) do
    Repo.get_by!(Ticker, symbol: ticker)
  end

  def has_ticker?(ticker) do
    query = from t in Ticker, where: t.symbol == ^ticker
    Repo.exists?(query)
  end
end
