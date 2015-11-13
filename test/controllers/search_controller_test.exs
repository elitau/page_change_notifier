defmodule PageChangeNotifier.SearchControllerTest do
  use PageChangeNotifier.ConnCase

  test "GET /search" do
    conn = get conn(), "/search", q: "query string"
    assert html_response(conn, 200) =~ "Search Results"
    assert html_response(conn, 200) =~ "query string"
  end
end
