defmodule PageChangeNotifier.NotifierTest do
  use PageChangeNotifier.ModelCase
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  @user %{
    name: "name",
    yo_username: "yo_username",
    email: "email"
  }
  @search_agent %{url: "search_url", user: @user}
  @new_result %PageChangeNotifier.Result{url: "new_result_url", title: "CHESINI Rennrad RH: 62cm, komplett Campagnolo (Bianchi)"}
  @results [@new_result]

  test "notify per yo" do
    # searches = [%{user: @search_agent.user, results: @results}]
    use_cassette "yo_send_link" do
      PageChangeNotifier.Notifier.notify(@search_agent, @results)
    end
  end
end
