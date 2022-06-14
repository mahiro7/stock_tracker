defmodule StockTracker.Repo.Migrations.CreateStocks do
  use Ecto.Migration

  def change do
    create table (:stocks) do
      add :date, :naive_datetime
      add :open, :float
      add :high, :float
      add :low, :float
      add :close, :float
      add :volume, :integer
      add :ticker_id, references(:tickers)
    end
  end
end
