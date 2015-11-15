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
  @search_agent %PageChangeNotifier.SearchAgent{url: @ebay_url, user_id: 23}
  @user %PageChangeNotifier.User{
    name: "name",
    yo_username: "yo_username",
    yo_username: "email"
  }

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "remove existing results from current results" do
    use_cassette "ebay_fahrrad" do
      saved_result = Repo.insert! @existing_result
      new_results = NotifierJob.run(@ebay_url)
      new_urls = new_results |> Enum.map(fn(result) -> result.url end)
      assert Enum.member?(new_urls, @new_result_url)
      assert !Enum.member?(new_urls, @existing_result_url)
    end
  end

  test "save new results" do
    use_cassette "ebay_fahrrad" do
      NotifierJob.run(@ebay_url)
      new_results = NotifierJob.run(@ebay_url)
      assert new_results == []
    end
  end

  test "notify new results for all search agents" do
    use_cassette "ebay_fahrrad" do
      saved_result = Repo.insert! @existing_result
      user = Repo.insert! @user
      search_agent = Repo.insert!(Map.merge(@search_agent, %{user_id: user.id}))
      NotifierJob.search
      # NotifierJob.run(@ebay_url)
      new_results = NotifierJob.run(@ebay_url)
      assert new_results == []
    end
  end


end
