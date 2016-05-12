defmodule PageChangeNotifier.ImmoscoutExtractorTest do
  use PageChangeNotifier.ModelCase
  @immoscout_url "http://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Nordrhein-Westfalen/Koeln/Ehrenfeld/-/-/EURO--500,00"
  @first_immoscout_element "http://www.immobilienscout24.de/expose/88017236"

  test "factory" do
    extractor = PageChangeNotifier.Extractor.for(@immoscout_url)
    assert extractor == PageChangeNotifier.Extractor.Immoscout
  end

  test "extract elements" do
    elements = PageChangeNotifier.Extractor.Immoscout.to_elements(fixture_html("immoscout"))
    assert {"li", _, _} = Enum.at(elements, 0)
  end

  test "extract url" do
    results = PageChangeNotifier.Extractor.Immoscout.extract_results(fixture_html("immoscout"))
    assert Enum.at(results, 0).url == @first_immoscout_element
    results |> Enum.map(
      fn(result) ->
        assert result.url =~ ~r/immobilienscout24/
      end
    )
  end

  def fixture_html(name) do
    path = Path.join(app_root, "test/fixtures/#{name}_results.html")
    case File.read(path) do
      {:ok, body}      -> body
      {:error, reason} -> {:error, reason}
    end
  end

  defp app_root do
    Application.get_env(:page_change_notifier, PageChangeNotifier.Endpoint)[:root]
  end
end
