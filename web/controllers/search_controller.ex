defmodule PageChangeNotifier.SearchController do
  use PageChangeNotifier.Web, :controller

  def search(conn, %{"q" => query}) do
    render conn, "results.html", query: query, results: results(query)
  end

  def results(query) do
    PageChangeNotifier.Search.run(query)
  end
end
