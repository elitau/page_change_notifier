defmodule PageChangeNotifier.EbayKleinanzeigenExtractorTest do
  use PageChangeNotifier.DataCase

  @url "https://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"

  import PageChangeNotifier.Extractor.EbayKleinanzeigen
  import PageChangeNotifier.Webpage
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "factory" do
    assert PageChangeNotifier.Extractor.EbayKleinanzeigen = PageChangeNotifier.Extractor.for(@url)
  end

  test "extract url" do
    use_cassette "ebay_fahrrad" do
      assert results() |> Enum.all?(&(&1.url =~ ~r/ebay/))
    end
  end

  test "finds all entries" do
    use_cassette "ebay_fahrrad" do
      assert 25 == results() |> length
    end
  end

  def results do
    @url |> get_body() |> extract_results()
  end
end
