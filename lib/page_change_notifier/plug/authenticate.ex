defmodule PageChangeNotifier.Plug.Authenticate do
  import Plug.Conn
  import PageChangeNotifier.Router.Helpers
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, default) do
    current_user = get_session(conn, :current_user)
    if current_user do
      assign(conn, :current_user, current_user)
    else
      # assign(conn, :current_user, nil)
      conn
        |> put_flash(:error, 'You need to be signed in to view this page')
        |> redirect(to: page_path(conn, :login))
    end
  end
end
