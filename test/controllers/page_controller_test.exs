defmodule PageChangeNotifier.PageControllerTest do
  use PageChangeNotifier.ConnCase

  setup do
    user = Repo.insert! %PageChangeNotifier.User{ username: "luke" }
    conn = conn()
           |> put_private(:authenticated_current_user_id, user.id)

    {:ok, conn: conn}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "search"
  end
end
