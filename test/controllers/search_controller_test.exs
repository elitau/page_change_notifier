defmodule PageChangeNotifier.SearchControllerTest do
  use PageChangeNotifier.ConnCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
  end

  setup do
    user = Repo.insert! %PageChangeNotifier.User{ username: "luke" }
    conn = conn()
           |> put_private(:authenticated_current_user_id, user.id)

    {:ok, conn: conn}
  end

  test "GET /search", %{conn: conn} do
    ebay_url = "http://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"
    use_cassette "ebay_fahrrad" do
      conn = get conn, "/search", q: ebay_url
      assert html_response(conn, 200) =~ "Search Results"
      assert html_response(conn, 200) =~ "fahrradrahmen"
      assert html_response(conn, 200) =~ "Pulverbeschichtung"
      assert html_response(conn, 200) =~ "campagnolo"
    end
  end
end
