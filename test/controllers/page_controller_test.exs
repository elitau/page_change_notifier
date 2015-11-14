defmodule PageChangeNotifier.PageControllerTest do
  use PageChangeNotifier.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Search"
  end
end
