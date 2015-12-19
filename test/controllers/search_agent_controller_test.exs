defmodule PageChangeNotifier.SearchAgentControllerTest do
  use PageChangeNotifier.ConnCase

  alias PageChangeNotifier.SearchAgent
  alias PageChangeNotifier.Result
  @valid_attrs %{url: "some content"}
  @invalid_attrs %{}

  setup do
    user = Repo.insert! %PageChangeNotifier.User{ username: "luke" }
    conn = conn()
           |> put_private(:authenticated_current_user_id, user.id)

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, search_agent_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing search agents"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, search_agent_path(conn, :new)
    assert html_response(conn, 200) =~ "New search agent"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, search_agent_path(conn, :create), search_agent: @valid_attrs
    assert redirected_to(conn) == search_agent_path(conn, :index)
    assert Repo.get_by(SearchAgent, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, search_agent_path(conn, :create), search_agent: @invalid_attrs
    assert html_response(conn, 200) =~ "New search agent"
  end

  test "shows chosen resource", %{conn: conn} do
    search_agent = Repo.insert! %SearchAgent{}
    conn = get conn, search_agent_path(conn, :show, search_agent)
    assert html_response(conn, 200) =~ "Show search agent"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, search_agent_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    search_agent = Repo.insert! %SearchAgent{}
    conn = get conn, search_agent_path(conn, :edit, search_agent)
    assert html_response(conn, 200) =~ "Edit search agent"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    search_agent = Repo.insert! %SearchAgent{}
    conn = put conn, search_agent_path(conn, :update, search_agent), search_agent: @valid_attrs
    assert redirected_to(conn) == search_agent_path(conn, :show, search_agent)
    assert Repo.get_by(SearchAgent, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    search_agent = Repo.insert! %SearchAgent{}
    conn = put conn, search_agent_path(conn, :update, search_agent), search_agent: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit search agent"
  end

  test "deletes chosen resource", %{conn: conn} do
    search_agent = Repo.insert! %SearchAgent{url: "url"}
    result = Repo.insert! %Result{search_agent_id: search_agent.id}
    conn = delete conn, search_agent_path(conn, :delete, search_agent)
    assert redirected_to(conn) == search_agent_path(conn, :index)
    refute Repo.get(SearchAgent, search_agent.id)
    refute Repo.get(Result, result.id)
  end
end
