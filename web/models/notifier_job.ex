defmodule PageChangeNotifier.NotifierJob do
  def run(url) do
    without_existing(PageChangeNotifier.Search.run(url), PageChangeNotifier.Repo.all(PageChangeNotifier.Result))
  end

  def without_existing(results, existing_results) do
    existing_urls = existing_results |> Enum.map(fn(result) -> result.url end)
    results |> Enum.filter(fn(result) -> !Enum.member?(existing_urls, result.url) end)
  end

  def notify(results) do
    results
  end
end
