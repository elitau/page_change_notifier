defmodule PageChangeNotifier.SessionControllerTest do
  use PageChangeNotifier.ConnCase

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn(), "/login"
    assert html_response(conn, 200) =~ "Login"
  end
end
