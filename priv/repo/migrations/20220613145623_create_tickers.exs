defmodule StockTracker.Repo.Migrations.CreateTickers do
  use Ecto.Migration

  def change do
    create table(:tickers) do
      add :symbol, :string
    end
  end
end
