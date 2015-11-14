defmodule PageChangeNotifier.NotifierJobTest do
  use PageChangeNotifier.ModelCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PageChangeNotifier.NotifierJob
  @existing_result_url "http://www.ebay-kleinanzeigen.de/s-anzeige/fahrradrahmen-pulverbeschichten-fahrrad-rahmen-pulverbeschichtung/360494180-298-20668"
  @new_result_url "http://www.ebay-kleinanzeigen.de/s-anzeige/chesini-rennrad-rh-62cm,-komplett-campagnolo-bianchi-/380914335-217-947"
  @existing_result %PageChangeNotifier.Result{url: @existing_result_url, title: "Fahrradrahmen pulverbeschichten Fahrrad Rahmen Pulverbeschichtung"}
  @new_result %PageChangeNotifier.Result{url: @new_result_url, title: "CHESINI Rennrad RH: 62cm, komplett Campagnolo (Bianchi)"}
  @ebay_url "http://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "remove existing results from current results" do
    use_cassette "ebay_fahrrad" do
      saved_result = Repo.insert! @existing_result
      new_results = NotifierJob.run(@ebay_url)
      new_urls = new_results |> Enum.map(fn(result) -> result.url end)
      # assert new_results == []
      assert Enum.member?(new_urls, @new_result_url)
      assert !Enum.member?(new_urls, @existing_result_url)
      # assert saved_result == new_urls
      # assert 1 == new_results
    end
  end
end
