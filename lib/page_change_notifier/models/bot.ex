defmodule PageChangeNotifier.Bot do
  alias PageChangeNotifier.{User, Repo, SearchAgent}

  def message_received(%{"text" => "https://www.immobilienscout24.de" <> _path = url} = message) do
    user = user(message)

    case Repo.get_by(SearchAgent, url: url, user_id: user.id) do
      nil ->
        Repo.insert!(%SearchAgent{url: url, user_id: user.id})
        "Search for " <> url <> " added."

      %SearchAgent{} ->
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
    chat_id = message["chat"]["id"] |> to_string()

    case Repo.get_by(User, telegram_chat_id: chat_id) do
      nil ->
        chat_id |> create_bot_user()

      %User{} = user ->
        user
    end
  end

  def create_bot_user(chat_id) do
    Repo.insert!(%User{
      username: chat_id |> bot_username(),
      telegram_chat_id: chat_id
    })
  end

  def bot_username(chat_id) do
    "bot_user_" <> chat_id
  end
end
