defmodule PageChangeNotifier.PageController do
  use PageChangeNotifier.Web, :controller
  plug PageChangeNotifier.Plug.Authenticate

  def index(conn, _params) do
    render conn, "index.html"
  end

  # def login(conn, _params) do
  #   # assign(conn, :current_user, "")
  #   render conn, "login.html"
  # end

  # def logout(conn, _params) do
  #   Plug.Conn.configure_session(conn, drop: true)
  #   # assign(conn, :current_user, nil)
  #   conn
  #   |> put_flash(:info, "Logged out.")
  #   |> redirect(to: page_path(conn, :login))
  # end

  # def create_or_login(conn, %{"username" => username}) do
  #   put_session(conn, :current_user, username)
  #   |> put_flash(:info, "Logged in successfully.")
  #   |> redirect(to: search_agent_path(conn, :index))
  # end
end
