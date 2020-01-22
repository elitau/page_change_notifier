defmodule PageChangeNotifier.IntegrationTest do
  use PageChangeNotifier.DataCase

  @moduledoc """
  Executes search without mocking!
  """

  # returned 123 results
  @immoscout_url "https://www.immobilienscout24.de/Suche/de/nordrhein-westfalen/koeln/wohnung-mieten?geocodes=1276010028020,1276010028001&enteredFrom=result_list"

  test "finds all entries of first result page" do
    results_count =
      @immoscout_url
      |> PageChangeNotifier.Search.run()
      |> length

    assert results_count == 20
  end
end
