defmodule PageChangeNotifier.TelegramView do
  use PageChangeNotifier.Web, :view

  def render("webhook.json", %{message: message}) do
    message
  end
end
