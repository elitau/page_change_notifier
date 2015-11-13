defmodule PageChangeNotifier.Search do
  # use PageChangeNotifier.Web, :model
  def run(page_url) do
    page_url |> get_page_html |> extract_results
  end

  def get_page_html(page_url) do
    PageChangeNotifier.Webpage.get_body(page_url)
  end

  def extract_results(page_html) do
    page_html |> Floki.find("article h2 a") |> Floki.attribute("href")
  end
end
