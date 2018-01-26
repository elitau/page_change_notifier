defmodule PageChangeNotifierWeb.SearchAgentController do
  use PageChangeNotifierWeb, :controller

  alias PageChangeNotifier.SearchAgent
  alias PageChangeNotifier.Repo

  plug(PageChangeNotifierWeb.Plug.Authenticate)
  plug(:scrub_params, "search_agent" when action in [:create, :update])

  def index(conn, _params) do
    search_agents =
      if conn.assigns[:current_user].username == "zecke" do
        Repo.all(SearchAgent)
      else
        Repo.all(Ecto.assoc(conn.assigns[:current_user], :search_agents))
      end

    render(conn, "index.html", search_agents: search_agents)
  end

  def new(conn, _params) do
    changeset = SearchAgent.changeset(%SearchAgent{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"search_agent" => search_agent_params}) do
    params = Map.merge(search_agent_params, %{"user_id" => conn.assigns[:current_user].id})
    changeset = SearchAgent.changeset(%SearchAgent{}, params)

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
    render(conn, "show.html", search_agent: search_agent, new_results: search_agent.results)
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
    search_agent.results |> Enum.map(fn result -> Repo.delete!(result) end)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(search_agent)

    conn
    |> put_flash(:info, "Search agent deleted successfully.")
    |> redirect(to: search_agent_path(conn, :index))
  end
end
