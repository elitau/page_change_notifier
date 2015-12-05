defmodule PageChangeNotifier.SessionControllerTest do
  use PageChangeNotifier.ConnCase

  @valid_attrs %{username: "luke"}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "render login template", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login or register"
  end

  test "create user", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert html_response(conn, 302)
    assert Repo.get_by(PageChangeNotifier.User, username: "luke")
  end
end
