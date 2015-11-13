defmodule PageChangeNotifier.Search do
  def run(page_url) do
    page_url |> get_page_html |> extract_results
  end

  def get_page_html(page_url) do
    PageChangeNotifier.Webpage.get_body(page_url)
  end

  def extract_results(page_html) do
    page_html |> Floki.find("article h2 a") |> Floki.attribute("href") |> to_ebay_url
  end

  def to_ebay_url(paths) do
    paths |> Enum.map(fn(path) -> prepend_ebay_domain(path) end)
  end

  def prepend_ebay_domain(path) do
    "http://www.ebay-kleinanzeigen.de#{path}"
  end
end
