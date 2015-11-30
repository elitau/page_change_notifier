defmodule PageChangeNotifier.Webpage do
  use HTTPoison.Base

  def get_body do
    "<html></html>"
  end

  def get_body(page_url) do
    HTTPoison.start
    HTTPoison.get!(page_url).body
  end
end
