defmodule PageChangeNotifier.NotifierJob do
  alias PageChangeNotifier.Result

  def search do
    search_agents |> new_results |> notify_searches
  end

  def run(url) do
    without_existing(PageChangeNotifier.Search.run(url), PageChangeNotifier.Repo.all(Result))
    |> save
    |> notify
  end

  def run do
    search
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

  def notify_searches(searches) do
    searches |> Enum.map(fn(search) -> notify_search(search) end)
  end

  def notify_search(search) do
    PageChangeNotifier.Notifier.notify(search.search_agent, search.results)
  end

  # def notify(%{user: user, results: results}) do
  #   PageChangeNotifier.Mailer.send_new_results_text_email("duarde.taulie@gmail.com", results)
  # end

  def notify([]) do
    []
  end

  def notify(results) do
    PageChangeNotifier.Mailer.send_new_results_text_email("duarde.taulie@gmail.com", results)
    results
  end

  def search_agents do
    PageChangeNotifier.Repo.all(PageChangeNotifier.SearchAgent) |> PageChangeNotifier.Repo.preload(:user)
  end

  def new_results(search_agents) do
    search_agents |> Enum.map(
      fn(search_agent) -> %{search_agent: search_agent, results: new_results_for(search_agent)} end
    )
  end

  def new_results_for(search_agent) do
    without_existing(
      current_results(search_agent),
      PageChangeNotifier.Repo.all(Result)
    ) |> save
  end

  def current_results(search_agent) do
    PageChangeNotifier.Search.run(search_agent.url)
  end

end
