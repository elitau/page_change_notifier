defmodule PageChangeNotifier.SearchTest do
  use PageChangeNotifier.DataCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PageChangeNotifier.Search
  @ebay_url "https://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"
  @first_element "https://www.ebay-kleinanzeigen.de/s-anzeige/24-zoll-fahrrad/955764384-217-981"
  @valid_url_schema "https://www.ebay-kleinanzeigen.de/s-anzeige"

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "fetch html" do
    use_cassette "ebay_fahrrad" do
      html = Search.get_page_html(@ebay_url)
      assert html =~ "Fahrrad"
    end
  end

  test "extract results" do
    use_cassette "ebay_fahrrad" do
      results = Search.run(@ebay_url)
      assert Enum.at(results, 0).url == @first_element
    end
  end

  test "return empty array on unsupported website url" do
    results = Search.run("unsupported.url")
    assert length(results) == 0
  end

  test "assert valid url" do
    use_cassette "ebay_fahrrad" do
      results = Search.run(@ebay_url)
      {:ok, regexp} = Regex.compile(@valid_url_schema)
      assert Enum.filter(results, fn result -> !(result.url =~ regexp) end) == []
    end
  end
end
