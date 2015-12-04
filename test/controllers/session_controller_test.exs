defmodule PageChangeNotifier.SessionControllerTest do
  use PageChangeNotifier.ConnCase

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "render login template", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login or register"
  end
end
