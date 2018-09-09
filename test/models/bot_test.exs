defmodule PageChangeNotifier.BotTest do
  use PageChangeNotifier.DataCase
  alias PageChangeNotifier.Bot

  @immoscout_url "http://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Nordrhein-Westfalen/Koeln/Ehrenfeld/-/-/EURO--500,00"
  @message %{"chat" => %{"id" => 23}}

  test "Hi" do
    assert ~s{Hi! I can search for things and notify you. Copy the URL of the search results page and send it to me.} ==
             Bot.message_received("Hi")
  end

  describe "user management" do
    test "creates bot user for unknown chat id" do
      assert %PageChangeNotifier.User{telegram_chat_id: 23, username: "bot_user_23"} =
               Bot.user(@message)
    end

    test "uses existing bot user if chat id is known" do
      Repo.insert!(%PageChangeNotifier.User{username: "bot_user", telegram_chat_id: 23})
    end
  end
end
