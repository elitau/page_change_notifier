defmodule PageChangeNotifier.SessionControllerTest do
  use PageChangeNotifierWeb.ConnCase
  alias PageChangeNotifier.Repo
  @valid_attrs %{username: "luke"}

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "render login template", %{conn: conn} do
    conn = get(conn, session_path(conn, :new))
    assert html_response(conn, 200) =~ "Login or register"
  end

  test "create user", %{conn: conn} do
    conn = post(conn, session_path(conn, :create), user: @valid_attrs)
    assert html_response(conn, 302)
    user = Repo.get_by(PageChangeNotifier.User, username: "luke")
    assert user
    assert redirected_to(conn) == user_path(conn, :edit, user)
  end

  test "login user if username matches existing user", %{conn: conn} do
    Repo.insert!(%PageChangeNotifier.User{username: "luke"})
    conn = post(conn, session_path(conn, :create), user: @valid_attrs)
    assert redirected_to(conn) == search_agent_path(conn, :index)
    assert html_response(conn, 302)
  end
end
