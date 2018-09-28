defmodule PageChangeNotifier.Bot do
  alias PageChangeNotifier.{User, Repo, SearchAgent}
  import User

  def message_received(%{"text" => "/add " <> url} = message) do
    user = user(message)

    case Repo.get_by(SearchAgent, url: url, user_id: user.id) do
      nil ->
        user |> add_search(url)
        "Search for " <> url <> " added."

      %SearchAgent{} ->
        "Search for " <> url <> " was already added."
    end <> " I will post new results to this chat."
  end

  def message_received(%{"text" => "/remove " <> url} = message) do
    user = user(message)

    case Repo.get_by(SearchAgent, url: url, user_id: user.id) do
      nil ->
        "I have no search with URL: " <> url

      %SearchAgent{} = search_agent ->
        Repo.delete(search_agent)
        "Search for " <> url <> " was removed."
    end <> " Send me /list to see all searches"
  end

  def message_received(%{"text" => "/list"} = message) do
    Repo.all(Ecto.assoc(user(message), :search_agents))
    |> Enum.map(&("* " <> &1.url))
    |> Enum.join("\n")
  end

  def message_received(%{"text" => "/help"}) do
    """
    @neueZoneBot is a search bot that runs searches every 10 minutes and sends new results to this chat.

    Send me one of the following commands:
    /add URL    => Adds a new search (Sites I can search: immobilienscout24.de, ebay-kleinanzeigen.de)
    /remove URL => Remove a search (not implemented yet)
    /list       => List all active searches
    /help       => This help message
    /addhelp    => Explanation on how to add a search
    """
  end

  def message_received(%{"text" => "/addhelp"}) do
    """
       To add a search go to one of the supported sites(immobilienscout24.de,
       ebay-kleinanzeigen.de) and search for the thing you want. Then copy the
       URL of the search results. This is the URL you need to give me with
       /add URL
    """
  end

  def message_received(%{"text" => "/chat_id", "chat" => %{"id" => chat_id}}) do
    ~s{Your chat id is "#{chat_id}"}
  end

  def message_received(_message) do
    """
    Hi! I can search for things and notify you.
    Say /help for a complete list of commands that I understand.
    """
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
