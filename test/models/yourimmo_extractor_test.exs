defmodule PageChangeNotifier.YourimmoExtractorTest do
  use PageChangeNotifier.DataCase

  @yourimmo_url "https://www.yourimmo.de/suche?l=50823&r=5km&a=de.50823&t=all%3Arental&pf=&pt=1200&rf=3&sf=70&st="
  @first_yourimmo_element "https://www.yourimmo.de/immobilien/sofort-einziehen-es-lohnt-sich-8JP2CZ"

  test "factory" do
    extractor = PageChangeNotifier.Extractor.for(@yourimmo_url)
    assert extractor == PageChangeNotifier.Extractor.Yourimmo
  end

  test "extract elements" do
    first_element =
      "yourimmo"
      |> fixture_html()
      |> PageChangeNotifier.Extractor.Yourimmo.to_elements()
      |> Enum.at(0)

    assert {"div", _, _} = first_element
  end

  test "extract url" do
    results =
      "yourimmo"
      |> fixture_html()
      |> PageChangeNotifier.Extractor.Yourimmo.extract_results()

    assert Enum.at(results, 0).url == @first_yourimmo_element

    results
    |> Enum.map(fn result ->
      assert result.url =~ ~r/yourimmo/
    end)
  end

  test "finds all entries except immoscout source" do
    results_count =
      "yourimmo"
      |> fixture_html()
      |> PageChangeNotifier.Extractor.Yourimmo.extract_results()
      |> length

    assert results_count == 4
  end

  def fixture_html(name) do
    path = Path.join(File.cwd!(), "test/fixtures/#{name}.html")

    case File.read(path) do
      {:ok, body} -> body
      {:error, reason} -> {:error, reason}
    end
  end
end
