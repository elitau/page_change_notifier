defmodule PageChangeNotifier.SearchAgentController do
  use PageChangeNotifier.Web, :controller

  alias PageChangeNotifier.SearchAgent

  plug :scrub_params, "search_agent" when action in [:create, :update]
  plug PageChangeNotifier.Plug.Authenticate

  def index(conn, _params) do
    search_agents = Repo.all(SearchAgent)
    render(conn, "index.html", search_agents: search_agents)
  end

  def new(conn, _params) do
    changeset = SearchAgent.changeset(%SearchAgent{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"search_agent" => search_agent_params}) do
    changeset = SearchAgent.changeset(%SearchAgent{}, search_agent_params)

    case Repo.insert(changeset) do
      {:ok, _search_agent} ->
        conn
        |> put_flash(:info, "Search agent created successfully.")
        |> redirect(to: search_agent_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    search_agent = Repo.get!(SearchAgent, id) |> PageChangeNotifier.Repo.preload(:results)
    # search = PageChangeNotifier.NotifierJob.new_result(search_agent)
    render(conn, "show.html", search_agent: search_agent, new_results: []) #search.new_results)
  end

  def edit(conn, %{"id" => id}) do
    search_agent = Repo.get!(SearchAgent, id)
    changeset = SearchAgent.changeset(search_agent)
    render(conn, "edit.html", search_agent: search_agent, changeset: changeset)
  end

  def update(conn, %{"id" => id, "search_agent" => search_agent_params}) do
    search_agent = Repo.get!(SearchAgent, id)
    changeset = SearchAgent.changeset(search_agent, search_agent_params)

    case Repo.update(changeset) do
      {:ok, search_agent} ->
        conn
        |> put_flash(:info, "Search agent updated successfully.")
        |> redirect(to: search_agent_path(conn, :show, search_agent))
      {:error, changeset} ->
        render(conn, "edit.html", search_agent: search_agent, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    search_agent = Repo.get!(SearchAgent, id) |> PageChangeNotifier.Repo.preload(:results)
    search_agent.results |> Enum.map(fn(result) -> Repo.delete!(result) end)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(search_agent)

    conn
    |> put_flash(:info, "Search agent deleted successfully.")
    |> redirect(to: search_agent_path(conn, :index))
  end
end
