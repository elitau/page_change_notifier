defmodule PageChangeNotifier.SearchController do
  use PageChangeNotifier.Web, :controller

  def search(conn, %{"q" => query}) do
    existing_results = PageChangeNotifier.Repo.all(PageChangeNotifier.Result)
    new_results = PageChangeNotifier.NotifierJob.run(query)
    render conn, "results.html", query: query, existing_results: existing_results, new_results: new_results
  end
end
