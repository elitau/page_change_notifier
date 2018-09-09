defmodule PageChangeNotifier.Bot do
  alias PageChangeNotifier.User
  alias PageChangeNotifier.Repo

  def message_received(%{"text" => "https://www.immobilienscout24.de" <> _path = url} = message) do
    user = user(message)

    case PageChangeNotifier.Repo.get_by(
           PageChangeNotifier.SearchAgent,
           url: url,
           user_id: user.id
         ) do
      nil ->
        PageChangeNotifier.Repo.insert!(%PageChangeNotifier.SearchAgent{
          url: url,
          user_id: user.id
        })

        "Search for " <> url <> " added."

      _search_agent ->
        "Search for " <> url <> " was already added."
    end <> "I will post new results to this chat."
  end

  def message_received(%{"text" => "list"} = message) do
    Repo.all(Ecto.assoc(user(message), :search_agents))
    |> Enum.map(&("* " <> &1.url))
    |> Enum.join()
  end

  def message_received(_message) do
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
