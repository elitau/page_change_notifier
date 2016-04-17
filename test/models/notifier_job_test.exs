defmodule PageChangeNotifier.NotifierJobTest do
  use PageChangeNotifier.ModelCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PageChangeNotifier.NotifierJob
  @ebay_url "http://www.ebay-kleinanzeigen.de/s-50937/fahrrad/k0l18675r5"
  @existing_result_url "http://www.ebay-kleinanzeigen.de/s-anzeige/lauflernrad/393002485-217-981"
  @kalaydo_url "http://www.kalaydo.de/kleinanzeigen/2/3/k/fahrrad/?LOCATION=250667010&DISTANCE=100"
  @first_kalaydo_element "http://www.kalaydo.de/kleinanzeigen/mountainbike/kinderfahrrad-mtb-26-zoll-zuendapp/a/83037515/"
  @search_agent %PageChangeNotifier.SearchAgent{url: @ebay_url, user_id: 23}
  @kalaydo_search_agent %PageChangeNotifier.SearchAgent{url: @kalaydo_url, user_id: 23}
  @new_result_url "http://www.ebay-kleinanzeigen.de/s-anzeige/silbernes-mountainbike/393097973-217-20670"
  @existing_result %PageChangeNotifier.Result{url: @existing_result_url, title: "Fahrradrahmen pulverbeschichten Fahrrad Rahmen Pulverbeschichtung"}
  @kalaydo_existing_result %PageChangeNotifier.Result{url: @first_kalaydo_element, title: "dunno title"}
  @new_result %PageChangeNotifier.Result{url: @new_result_url, title: "CHESINI Rennrad RH: 62cm, komplett Campagnolo (Bianchi)"}
  @user %PageChangeNotifier.User{
    username: "username",
    yo_username: "yo_username",
    email: "email"
  }

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "remove existing results from current results" do
    use_cassette "ebay_fahrrad_and_yo" do
      user = Repo.insert! @user
      search_agent = Repo.insert!(Map.merge(@search_agent, %{"user_id": user.id}))
      saved_result = Repo.insert!(Map.merge(@existing_result, %{search_agent_id: search_agent.id}))
      searches_with_results = NotifierJob.run #(@ebay_url)
      new_results = Enum.at(searches_with_results, 0).new_results
      new_urls = new_results |> Enum.map(fn(result) -> result.url end)
      assert Enum.member?(new_urls, @new_result_url)
      assert !Enum.member?(new_urls, @existing_result_url)
    end
  end

  test "save new results" do
    use_cassette "ebay_fahrrad_and_yo" do
      user = Repo.insert! @user
      search_agent = Repo.insert!(Map.merge(@search_agent, %{user_id: user.id}))
      NotifierJob.run

      result = Repo.get_by(PageChangeNotifier.Result, url: @new_result_url)
      assert result.id
      assert result.search_agent_id == search_agent.id
    end
  end

  test "kalaydo results" do
    use_cassette "kalaydo_fahrrad_and_yo" do
      user = Repo.insert! @user
      search_agent = Repo.insert!(Map.merge(@kalaydo_search_agent, %{user_id: user.id}))
      searches_with_results = NotifierJob.run

      result = Repo.get_by(PageChangeNotifier.Result, url: @first_kalaydo_element)
      assert result.id
      assert result.search_agent_id == search_agent.id
      all = PageChangeNotifier.Repo.all(PageChangeNotifier.Result)
      assert 25 == Enum.count(all)

      new_results = Enum.at(searches_with_results, 0).new_results
      assert 25 == Enum.count(new_results)
    end
  end

  # test "notify new results for all search agents" do
  #   use_cassette "ebay_fahrrad_and_yo" do
  #     saved_result = Repo.insert! @existing_result
  #     user = Repo.insert! @user
  #     search_agent = Repo.insert!(Map.merge(@search_agent, %{user_id: user.id}))
  #     NotifierJob.search
  #     new_results = NotifierJob.run(@ebay_url)
  #     assert new_results == []
  #   end
  # end


end
