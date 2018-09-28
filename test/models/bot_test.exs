defmodule PageChangeNotifier.BotTest do
  use PageChangeNotifier.DataCase
  alias PageChangeNotifier.{Bot, User, SearchAgent}

  @immoscout_url "https://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Nordrhein-Westfalen/Koeln/Ehrenfeld/-/-/EURO--500,00"
  @message %{"chat" => %{"id" => "23"}, "text" => "/add " <> @immoscout_url}

  test "Unknown message" do
    assert @message |> Map.merge(%{"text" => "hi"}) |> Bot.message_received() =~ ~s{Hi! I can}
  end

  test "help command" do
    assert @message |> Map.merge(%{"text" => "/help"}) |> Bot.message_received() =~
             ~s{following commands}
  end

  test "chat_id command" do
    assert @message |> Map.merge(%{"text" => "/chat_id"}) |> Bot.message_received() =~
             ~s{Your chat id is "23"}
  end

  test "message without text does not break a thing" do
    assert @message |> Map.delete("text") |> Bot.message_received()
  end

  describe "adds a url" do
    test "with immoscrout host" do
      assert "Search for " <> @immoscout_url <> " added." <> _info =
               Bot.message_received(@message)
    end

    test "adds search agent for user" do
      Bot.message_received(@message)
      assert PageChangeNotifier.Repo.get_by!(SearchAgent, url: @immoscout_url)
    end
  end

  describe "removed a url" do
    test "if it can be found" do
      fake_search_agent("some_url")

      assert @message |> change_text("/remove some_url") |> Bot.message_received() =~
               "was removed"

      refute PageChangeNotifier.Repo.get_by(SearchAgent, url: "some_url")
    end

    test "if there is no search agent with the url" do
      fake_search_agent("some_url")

      assert @message |> change_text("/remove other_url") |> Bot.message_received() =~
               "no search with URL: other_url"

      assert PageChangeNotifier.Repo.get_by!(SearchAgent, url: "some_url")
    end
  end

  describe "list search agents" do
    test "list" do
      fake_search_agent("some_url", "23")

      assert "* " <> "some_url" = @message |> change_text("/list") |> Bot.message_received()
    end
  end

  describe "user management" do
    test "creates bot user for unknown chat id" do
      assert %PageChangeNotifier.User{telegram_chat_id: "23", username: "bot_user_23"} =
               Bot.user(@message)
    end

    test "uses existing bot user if chat id is known" do
      existing_user = Repo.insert!(%User{username: "bot_user", telegram_chat_id: "23"})
      assert existing_user == Bot.user(@message)
    end
  end

  def change_text(message, new_text) do
    message |> Map.merge(%{"text" => new_text})
  end

  def fake_search_agent(url, telegram_chat_id \\ "23") do
    user = Repo.insert!(%User{username: "bot_user", telegram_chat_id: telegram_chat_id})

    PageChangeNotifier.Repo.insert!(%SearchAgent{
      url: url,
      user_id: user.id
    })
  end
end
