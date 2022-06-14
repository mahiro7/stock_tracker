defmodule StockTrackerTest.AlphaVantageTest do
  use ExUnit.Case, async: true
  import Mox

  alias StockTracker.AlphaVantage

  @http_client HTTPoison.BaseMock
  @test_config http_client: @http_client, api_url: "api.com/query?symbol="
  @env Application.get_env(:stock_tracker, :alpha_vantage)
  @success_resp @env |> Keyword.get(:mock_success_response)
  @error_resp @env |> Keyword.get(:mock_error_response)

  test "should get stock from API" do
    expect(@http_client, :get, fn "api.com/query?symbol=IBM" -> {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}} end)

    assert match?({:ok, %{last_refreshed: "2022-06-09 19:55:00"}}, AlphaVantage.stock_request("IBM", @test_config))
  end

  test "should return error if request fails with status 200" do
    expect(@http_client, :get, fn "api.com/query?symbol=BADTICKER" -> {:ok, %HTTPoison.Response{body: @error_resp |> Jason.encode!(), status_code: 200}} end)

    assert {:error, "Invalid ticker"} == AlphaVantage.stock_request("badticker", @test_config)
  end

  test "should return error if request fails with another status" do
    expect(@http_client, :get, fn "api.com/query?symbol=IBM" -> {:error, %HTTPoison.Response{body: "", status_code: 500}} end)

    assert {:error, "Error on request"} == AlphaVantage.stock_request("IBM", @test_config)
  end

  test "should treat time series received from API" do
    expect(@http_client, :get, fn "api.com/query?symbol=IBM" -> {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}} end)

    {:ok, %{time_series: time_series}} = AlphaVantage.stock_request("IBM", @test_config)

    assert time_series == %{
        "2022-06-09 19:55:00" => %{
            "1. open" => "137.9600",
            "2. high" => "137.9600",
            "3. low" => "137.9600",
            "4. close" => "137.9600",
            "5. volume" => "300"
        },
        "2022-06-09 19:15:00" => %{
            "1. open" => "138.0200",
            "2. high" => "138.0200",
            "3. low" => "138.0000",
            "4. close" => "138.0000",
            "5. volume" => "515"
        },
        "2022-06-09 18:35:00" => %{
            "1. open" => "138.2300",
            "2. high" => "138.2300",
            "3. low" => "138.2300",
            "4. close" => "138.2300",
            "5. volume" => "250"
        }
      }
  end
end
