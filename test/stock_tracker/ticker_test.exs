defmodule StockTrackerTest.TickerTest do
  use ExUnit.Case, async: true

  alias StockTracker.Ticker

  test "should create a ticker" do
    result = Ticker.create(symbol: "TESTE")

    #assert
  end

end
