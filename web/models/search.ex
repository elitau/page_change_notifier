defmodule PageChangeNotifier.Search do
  def run(page_url) do
    page_url |> get_page_html |> extract_results(page_url)
  end

  def get_page_html(page_url) do
    PageChangeNotifier.Webpage.get_body(page_url)
  end

  def extract_results(page_html, page_url) do
    extractor_for(page_url).extract_results(page_html)
  end

  def extractor_for(page_url) do
    PageChangeNotifier.Extractor.for(page_url)
  end
end
