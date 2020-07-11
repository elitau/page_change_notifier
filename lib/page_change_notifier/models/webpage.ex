defmodule PageChangeNotifier.Webpage do
  use HTTPoison.Base
  require Logger

  def get_body do
    "<html></html>"
  end

  def get_body(page_url) do
    try do
      HTTPoison.start()
      HTTPoison.get!(page_url |> URI.encode(), [], follow_redirect: true).body
    rescue
      HTTPoison.Error ->
        Logger.warn("Could not get #{page_url}")
        ""
    end
  end
end
