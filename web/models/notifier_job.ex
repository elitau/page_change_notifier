defmodule PageChangeNotifier.NotifierJob do
  alias PageChangeNotifier.Result
  def run do
    Airbrake.start

    try do
      search_agents |> new_results |> notify_users
    rescue
      exception -> Airbrake.report(exception)
    end
  end

  def search_agents do
    PageChangeNotifier.Repo.all(PageChangeNotifier.SearchAgent)
      |> PageChangeNotifier.Repo.preload(:results)
      |> PageChangeNotifier.Repo.preload(:user)
  end

  def new_results(search_agents) do
    search_agents |> Enum.map(
      fn(search_agent) -> %{search_agent: search_agent, new_results: new_results_for(search_agent)} end
    )
  end

  def new_results_for(search_agent) do
    search_agent
    |> current_results
    |> without_existing(search_agent)
    |> save(search_agent)
  end

  def current_results(search_agent) do
    PageChangeNotifier.Search.run(search_agent.url)
  end

  def without_existing(results, search_agent) do
    existing_urls = search_agent.results |> Enum.map(fn(result) -> result.url end)
    results |> Enum.filter(fn(result) -> !Enum.member?(existing_urls, result.url) end)
  end

  def save(results, search_agent) do
    results |> Enum.map(fn(result) -> save_result(result, search_agent) end)
  end

  def save_result(%Result{} = result, search_agent) do
    attributes = %{url: result.url, title: result.title}
    new_result = Ecto.Model.build(search_agent, :results, attributes)

    case PageChangeNotifier.Repo.insert(new_result) do
      {:ok, result} ->
        result
      {:error, changeset} ->
        changeset
    end
  end

  def notify_users(searches) do
    searches |> Enum.map(fn(search) -> notify_search(search) end)
    searches
  end

  def notify_search(search) do
    PageChangeNotifier.Notifier.notify(search.search_agent, search.new_results)
  end
end
