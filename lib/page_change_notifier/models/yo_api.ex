defmodule PageChangeNotifier.YoApi do
  @api_token "68236d9b-c9ab-43ec-addc-d869fbb84684"

  def send_link(username, link) do
    body = [username: username, link: link, api_token: @api_token]
    headers = %{"Content-type" => "application/x-www-form-urlencoded"}
    HTTPoison.start()
    HTTPoison.post("https://api.justyo.co/yo/", {:form, body}, headers)
  end
end
