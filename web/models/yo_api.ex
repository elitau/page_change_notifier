defmodule PageChangeNotifier.YoApi do
  # PageChangeNotifier.YoApi.send_link("hurx", "http://ede.li")
  def send_link(username, link) do
    headers = []
    api_token = "68236d9b-c9ab-43ec-addc-d869fbb84684" # searchnotifier
    ctype   = 'application/x-www-form-urlencoded'
    body    = URI.encode_query(%{username: username, link: link, api_token: api_token})
    opts = []
    url = String.to_char_list("https://api.justyo.co/yo/")
    :httpc.request(:post, {url, headers, ctype, body}, opts, body_format: :binary)
  end
end
