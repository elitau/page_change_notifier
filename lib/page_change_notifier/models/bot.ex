defmodule PageChangeNotifier.Bot do
  alias PageChangeNotifier.{User, Repo, SearchAgent}

  def message_received(%{"text" => "/add " <> url} = message) do
    user = user(message)

    case Repo.get_by(SearchAgent, url: url, user_id: user.id) do
      nil ->
        Repo.insert!(%SearchAgent{url: url, user_id: user.id})
        "Search for " <> url <> " added."

      %SearchAgent{} ->
        "Search for " <> url <> " was already added."
    end <> "I will post new results to this chat."
  end

  def message_received(%{"text" => "/list"} = message) do
    Repo.all(Ecto.assoc(user(message), :search_agents))
    |> Enum.map(&("* " <> &1.url))
    |> Enum.join()
  end

  def message_received(%{"text" => "/help"}) do
    """
    @neueZoneBot is a search bot that runs searches every 10 minutes and sends new results to this chat.

    Send me one of the following commands:
    /add URL    => Adds a new search
    /remove URL => Remove a search (not implemented yet)
    /list       => List all active searches
    /help       => This help message
    """
  end

  def message_received(_message) do
    """
    Hi! I can search for things and notify you.
    Copy the URL of the search results page and send it to me with a prepended /add.
    Here is an example of a message I understand:
    /add http://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Nordrhein-Westfalen/Koeln/Ehrenfeld/-/-/EURO--500,00

    Say /help for a complete list of allowed commands.
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
