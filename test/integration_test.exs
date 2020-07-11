defmodule PageChangeNotifier.IntegrationTest do
  use PageChangeNotifier.DataCase

  @moduledoc """
  Executes search without mocking!
  """

  # returned 123 results
  @immoscout_urls [
    "https://www.immobilienscout24.de/Suche/de/nordrhein-westfalen/koeln/wohnung-mieten?geocodes=1276010028020,1276010028001&enteredFrom=result_list",
    "https://www.immobilienscout24.de/Suche/de/nordrhein-westfalen/koeln/haus-kaufen?numberofrooms=4.0-&price=0.0-900000.0&livingspace=90.0-&geocodes=1276010028050,1276010028060,1276010028071,1276010028070,1276010028080,1276010028091,1276010028120,1276010028076,1276010028020,1276010028063,1276010028101,1276010028112,1276010028056,1276010028111,1276010028077,1276010028011,1276010028007,1276010028116,1276010028006,1276010028039,1276010028005,1276010028009&enteredFrom=saved_search",
    "https://www.immobilienscout24.de/Suche/radius/wohnung-mieten?centerofsearchaddress=Köln%3B%3B%3B1276010028101%3B%3BSülz&numberofrooms=4.0-&livingspace=100.0-&geocoordinates=50.916472195928584%3B6.927361154648593%3B2.0&enteredFrom=saved_search"
  ]

  test "finds all entries of first result page" do
    @immoscout_urls
    |> Enum.map(fn url ->
      assert results_count(url) > 0, "URL #{url} failed"
      # Test seems to be flaky: testing timeout
      Process.sleep(100)
    end)
  end

  defp results_count(url) do
    url
    |> PageChangeNotifier.Search.run()
    |> length
  end
end
