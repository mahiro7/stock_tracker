defmodule StockTracker.Router do
  use Plug.Router
  alias StockTracker.AlphaVantage

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)


  get "/status/:ticker" do
    try do
      {:ok, stock} = AlphaVantage.get_stock(ticker, conn.query_params)
      render_json(conn, stock)
    rescue
      _e in Ecto.NoResultsError ->
        conn
        |> put_status(404)
        |> render_json(%{message: "Not found"})
      _ ->
        conn
        |> put_status(500)
        |> render_json(%{message: "Internal server error"})
    end
  end


  post "/track" do
    with %{"symbol" => symbol} <- conn.body_params,
         {:ok} <- AlphaVantage.new_stock(symbol |> AlphaVantage.format_ticker()) do
            new_symbol = AlphaVantage.format_ticker(symbol)
            render_json(conn, %{message: "Stock #{new_symbol} tracked, use GET /status/#{new_symbol} to get its data"})
    else
      {:error, "Invalid ticker" = message} ->
        conn
        |> put_status(400)
        |> render_json(%{message: message})
      {:error, message} ->
        conn
        |> put_status(500)
        |> render_json(%{message: message})
      _ ->
        conn
        |> put_status(500)
        |> render_json(%{message: "Unkwown error"})
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp render_json(%{status: status} = conn, data) do
    body = Jason.encode!(data)
    send_resp(conn, (status || 200), body)
  end
end
