defmodule PageChangeNotifier.SearchControllerTest do
  use PageChangeNotifierWeb.ConnCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PageChangeNotifier.Repo

  setup do
    user = Repo.insert!(%PageChangeNotifier.User{username: "luke"})

    conn =
      build_conn()
      |> put_private(:authenticated_current_user_id, user.id)

    {:ok, conn: conn}
  end

  test "GET /search", %{conn: conn} do
    ebay_url = "https://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"

    use_cassette "ebay_fahrrad" do
      conn = get(conn, "/search", q: ebay_url)
      assert html_response(conn, 200) =~ "Search Results"
      assert html_response(conn, 200) =~ "24 zoll Fahrrad"
    end
  end
end
