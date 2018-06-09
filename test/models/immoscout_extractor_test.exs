defmodule PageChangeNotifier.ImmoscoutExtractorTest do
  use PageChangeNotifier.DataCase

  @immoscout_url "http://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Nordrhein-Westfalen/Koeln/Ehrenfeld/-/-/EURO--500,00"
  @first_immoscout_element "http://www.immobilienscout24.de/expose/88017236"

  test "factory" do
    extractor = PageChangeNotifier.Extractor.for(@immoscout_url)
    assert extractor == PageChangeNotifier.Extractor.Immoscout
  end

  test "extract elements" do
    first_element =
      "immoscout_results"
      |> fixture_html()
      |> PageChangeNotifier.Extractor.Immoscout.to_elements()
      |> Enum.at(0)

    assert {"li", _, _} = first_element
  end

  test "extract url" do
    results =
      "immoscout_results"
      |> fixture_html()
      |> PageChangeNotifier.Extractor.Immoscout.extract_results()

    assert Enum.at(results, 0).url == @first_immoscout_element

    results
    |> Enum.map(fn result ->
      assert result.url =~ ~r/immobilienscout24/
    end)
  end

  test "finds all entries" do
    results_count =
      "immoscout_results_2018_06-09"
      |> fixture_html()
      |> PageChangeNotifier.Extractor.Immoscout.extract_results()
      |> length

    assert results_count == 20
  end

  def fixture_html(name) do
    path = Path.join(File.cwd!(), "test/fixtures/#{name}.html")

    case File.read(path) do
      {:ok, body} -> body
      {:error, reason} -> {:error, reason}
    end
  end
end
