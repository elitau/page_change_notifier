defmodule PageChangeNotifier.SearchController do
  use PageChangeNotifier.Web, :controller

  def search(conn, %{"q" => query}) do
    render conn, "results.html", query: query
  end
end
