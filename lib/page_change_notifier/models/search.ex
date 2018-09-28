defmodule PageChangeNotifier.Search do
  require Logger

  def run do
    []
  end

  def run(%PageChangeNotifier.SearchAgent{url: url}) do
    run(url)
  end

  def run(page_url) when is_binary(page_url) do
    Logger.info("Running search for #{page_url}")

    case extractor_for(page_url) do
      {:no_extractor_defined, _page_url} ->
        Logger.info("Could not find extractor for #{page_url}")
        []

      extractor ->
        results = page_url |> get_page_html() |> extractor.extract_results
        Logger.info("Found #{results |> length() |> to_string()} results for #{page_url}")
        results
    end
  end

  def get_page_html(page_url) do
    PageChangeNotifier.Webpage.get_body(page_url)
  end

  def extractor_for(page_url) do
    PageChangeNotifier.Extractor.for(page_url)
  end
end
