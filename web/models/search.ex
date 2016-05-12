defmodule PageChangeNotifier.Search do
  def run do
    []
  end

  def run(page_url) do
    case extractor_for(page_url) do
      { :no_extractor_defined, page_url } ->
        []
      extractor ->
        get_page_html(page_url) |> extractor.extract_results
    end
  end

  def get_page_html(page_url) do
    PageChangeNotifier.Webpage.get_body(page_url)
  end

  def extractor_for(page_url) do
    PageChangeNotifier.Extractor.for(page_url)
  end
end
