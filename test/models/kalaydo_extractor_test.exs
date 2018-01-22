defmodule PageChangeNotifier.KalaydoExtractorTest do
  use PageChangeNotifier.DataCase

  @kalaydo_url "http://www.kalaydo.de/kleinanzeigen/2/3/k/fahrrad/?LOCATION=250667010&DISTANCE=100"
  @first_kalaydo_element "http://www.kalaydo.de/kleinanzeigen/mountainbike/kinderfahrrad-mtb-26-zoll-zuendapp/a/83037515/"

  test "factory" do
    extractor = PageChangeNotifier.Extractor.for(@kalaydo_url)
    assert extractor == PageChangeNotifier.Extractor.Kalaydo
  end

  test "extract elements" do
    elements = PageChangeNotifier.Extractor.Kalaydo.to_elements(fixture_html("kalaydo"))
    assert {"li", _, _} = Enum.at(elements, 0)
  end

  test "extract url" do
    results = PageChangeNotifier.Extractor.Kalaydo.extract_results(fixture_html("kalaydo"))
    assert Enum.at(results, 0).url == @first_kalaydo_element

    results
    |> Enum.map(fn result ->
      assert result.url =~ ~r/kleinanzeigen/
    end)
  end

  def fixture_html(name) do
    path = Path.join(File.cwd!(), "test/fixtures/#{name}_results.html")

    case File.read(path) do
      {:ok, body} -> body
      {:error, reason} -> {:error, reason}
    end
  end
end
