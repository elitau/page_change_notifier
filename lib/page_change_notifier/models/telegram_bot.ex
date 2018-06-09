defmodule PageChangeNotifier.TelegramBot do
  require Logger

  def send_message(chat_id, content) do
    Logger.info("TelegramBot: Sending message to ChatID #{chat_id}: #{content}")
    Nadia.send_message(chat_id, content)
  end
end
