defmodule StockTracker.RequestScheduler do
  use GenServer
  require Logger
  alias StockTracker.AlphaVantage

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(state) do
    ## Query database for existing tickers
    {:ok, state}
  end

  @impl true
  def handle_info({:work, ticker}, state) do
    schedule_work(ticker)
    {:noreply, state}
  end

  def schedule_work(ticker) do
    symbol = ticker.symbol
    |> AlphaVantage.update_stock(ticker)

    Process.send_after(self(), {:work, ticker}, 10 * 60 * 1000)
  end
end
