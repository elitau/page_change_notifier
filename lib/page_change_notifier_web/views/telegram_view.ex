defmodule PageChangeNotifierWeb.TelegramView do
  use PageChangeNotifierWeb, :view

  def render("webhook.json", %{message: message}) do
    message
  end
end
