defmodule StockTrackerTest.Router do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts StockTracker.Router.init([])

end
