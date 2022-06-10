defmodule StockTrackerTest do
  use ExUnit.Case
  doctest StockTracker

  test "greets the world" do
    assert StockTracker.hello() == :world
  end
end
