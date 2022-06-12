defmodule StockTrackerTest.AlphaVantageTest do
  use ExUnit.Case, async: true

  alias StockTracker.AlphaVantage

  test "should format stock ticker" do
    result = AlphaVantage.format_ticker("ibm")
    assert result == "IBM"

    result = AlphaVantage.format_ticker("iBm")
    assert result == "IBM"

    result = AlphaVantage.format_ticker("IBM")
    assert result == "IBM"
  end

  test "should get stock from API" do
    result = AlphaVantage.get("IBM")


  end

  test "should treat time series received from API" do

  end
end
