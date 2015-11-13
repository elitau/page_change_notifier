defmodule PageChangeNotifier.SearchTest do
  use PageChangeNotifier.ModelCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PageChangeNotifier.Search

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "fetch html" do
    ebay_url = "http://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"
    use_cassette "ebay_fahrrad" do
      html = Search.get_page_html(ebay_url)
      assert html =~ "Fahrrad"
    end
  end

  test "extract results" do
    results = Search.extract_results(example_html)
    assert Enum.at(results, 0) == "html"
  end

  def example_html do
    "html"
  end
end
