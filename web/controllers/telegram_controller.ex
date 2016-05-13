defmodule PageChangeNotifier.TelegramController do
  use PageChangeNotifier.Web, :controller
  require Logger

  def webhook(conn, params) do
    if params["message"]["chat"] != nil do
      id   = params["message"]["chat"]["id"]
      text = params["message"]["text"]
      from = params["message"]["from"]["first_name"]
      if text == "/id" do
        Nadia.send_message(id, id)
      else
        Nadia.send_message(id, "Hello. Type /id to get the chat_id.")
      end
    end
    render conn, message: text
  end
end
