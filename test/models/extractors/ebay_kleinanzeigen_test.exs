defmodule PageChangeNotifier.EbayKleinanzeigenExtractorTest do
  use PageChangeNotifier.DataCase

  @url "https://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"

  import PageChangeNotifier.Extractor.EbayKleinanzeigen
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/for_extractors")
  end

  test "factory" do
    assert PageChangeNotifier.Extractor.EbayKleinanzeigen = PageChangeNotifier.Extractor.for(@url)
  end

  test "extract url" do
    use_cassette "ebay_fahrrad" do
      @url
      |> PageChangeNotifier.Webpage.get_body()
      |> extract_results()
      |> Enum.map(fn result ->
        assert result.url =~ ~r/ebay\-kleinanzeigen/
      end)
    end
  end

  test "finds all entries" do
    use_cassette "ebay_fahrrad" do
      count =
        @url
        |> PageChangeNotifier.Webpage.get_body()
        |> extract_results()
        |> length

      assert count == 25
    end
  end

  def fixture_html(name) do
    path = Path.join(File.cwd!(), "test/fixtures/for_extractors/#{name}.html")

    case File.read(path) do
      {:ok, body} -> body
      {:error, reason} -> {:error, reason}
    end
  end
end
