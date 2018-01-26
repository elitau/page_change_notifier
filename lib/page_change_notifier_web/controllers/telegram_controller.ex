defmodule PageChangeNotifierWeb.TelegramController do
  use PageChangeNotifierWeb, :controller
  require Logger

  def webhook(conn, params) do
    text = ""

    if params["message"]["chat"] != nil do
      id = params["message"]["chat"]["id"]
      text = params["message"]["text"]
      # from = params["message"]["from"]["first_name"]
      Logger.info("TelegramController: Received message: #{text}")

      if text == "/chat_id" do
        Nadia.send_message(id, "Hello. Your chat id is #{id}")
      else
        Nadia.send_message(id, text)
      end
    end

    render(conn, message: "{}")
  end
end
