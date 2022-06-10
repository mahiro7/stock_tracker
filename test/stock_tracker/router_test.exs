defmodule StockTrackerTest.Router do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts StockTracker.Router.init([])

  test "returns OK" do
    conn = conn(:get, "/")

    request = StockTracker.Router.call(conn, @opts)

    assert request.state == :sent
    assert request.resp_body == "OK"
    assert request.status == 200
  end
end
