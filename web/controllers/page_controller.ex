defmodule PageChangeNotifier.PageController do
  use PageChangeNotifier.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
