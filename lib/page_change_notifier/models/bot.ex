defmodule PageChangeNotifier.Bot do
  alias PageChangeNotifier.User

  def message_received(%{"text" => text}) do
    text |> reply
  end

  def reply("http://www.immobilienscout24.de" <> _path = url) do
    "Search for " <> url <> " added"

    # case do
    #   () ->
    #     nil
    # end
  end

  def reply(_message) do
    ~s{Hi! I can search for things and notify you. Copy the URL of the search results page and send it to me.}
  end

  def user(message) do
    chat_id = message["chat"]["id"]

    case PageChangeNotifier.Repo.get_by(User, telegram_chat_id: chat_id) do
      nil ->
        PageChangeNotifier.Repo.insert!(%PageChangeNotifier.User{
          username: "bot_user_" <> (chat_id |> to_string()),
          telegram_chat_id: chat_id
        })

      user = %User{} ->
        user
    end
  end
end
