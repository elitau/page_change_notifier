defmodule PageChangeNotifier.SearchTest do
  use PageChangeNotifier.ModelCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PageChangeNotifier.Search
  @ebay_url "http://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"
  @first_element "http://www.ebay-kleinanzeigen.de/s-anzeige/fahrradrahmen-pulverbeschichten-fahrrad-rahmen-pulverbeschichtung/360494180-298-20668"

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
    results = Search.run(@ebay_url)
    assert Enum.at(results, 0) == @first_element
  end
end
