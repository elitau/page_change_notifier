defmodule PageChangeNotifierWeb.SearchController do
  use PageChangeNotifierWeb, :controller

  plug(PageChangeNotifierWeb.Plug.Authenticate)

  def search(conn, %{"q" => query}) do
    new_results = PageChangeNotifier.Search.run(query)
    render(conn, "results.html", query: query, new_results: new_results)
  end
end
