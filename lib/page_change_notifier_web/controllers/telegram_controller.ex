defmodule PageChangeNotifierWeb.TelegramController do
  use PageChangeNotifierWeb, :controller
  require Logger
  alias PageChangeNotifier.Bot

  defmodule TelegramNotConfigured do
    defexception [:message]
  end

  def webhook(conn, params) do
    # text = ""

    unless Application.get_env(:nadia, :token) do
      raise TelegramNotConfigured, "set TELEGRAM_BOT_TOKEN"
    end

    Logger.info("TelegramController: Received message: #{params |> inspect}")

    if params["message"]["chat"] != nil do
      chat_id = params["message"]["chat"]["id"]
      # text = params["message"]["text"]
      # from = params["message"]["from"]["first_name"]
      # user = Bot.user(chat_id)
      Logger.info("Chat_id:" <> inspect(chat_id))
      response = Bot.message_received(params["message"])
      Logger.info("Sending message " <> inspect(response) <> " to " <> inspect(chat_id))
      Nadia.send_message(chat_id, response)
    end

    render(conn, message: "{}")
  end
end
