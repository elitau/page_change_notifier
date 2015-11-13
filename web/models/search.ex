defmodule PageChangeNotifier.Search do
  # use PageChangeNotifier.Web, :model
  def run(page_url) do
    page_url |> get_page_html |> extract_results
  end

  def get_page_html(page_url) do
    "get_page_html"
  end

  def extract_results(page_html) do
    [page_html]
  end

end
