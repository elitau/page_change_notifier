defmodule PageChangeNotifier.NotifierJob do
  alias PageChangeNotifier.Result

  def run(url) do
    without_existing(PageChangeNotifier.Search.run(url), PageChangeNotifier.Repo.all(Result)) |> save
  end

  def without_existing(results, existing_results) do
    existing_urls = existing_results |> Enum.map(fn(result) -> result.url end)
    results |> Enum.filter(fn(result) -> !Enum.member?(existing_urls, result.url) end)
  end

  def save(results) do
    results |> Enum.map(fn(result) -> save_result(result) end)
  end

  def save_result(%Result{} = result) do
    attributes = %{url: result.url, title: result.title}
    changeset = Result.changeset(result, attributes)

    case PageChangeNotifier.Repo.insert(changeset) do
      {:ok, result} ->
        result
      {:error, changeset} ->
        changeset
    end
  end
end
