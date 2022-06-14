# StockTracker

## Running with Docker:
- ```docker-compose up -d```
- ```mix deps.get```
- ```mix ecto.create```
- ```mix ecto.migrate```
- ```mix run --no-halt```

## Running tests:
- ```mix test```

## Endpoints:
### POST localhost:8080/track
- Creates a new tracker for the ticker sent.
- Body: {"symbol": "ticker_symbol"}

### GET  localhost:8080/status/:symbol
- Returns all tracked data from a stock.
- Optional parameters:
  - start=timestamp (e.g. 2020-06-10 20:45:00)
  - end=timestamp
  - min_volume=integer
  - max_volume=integer
