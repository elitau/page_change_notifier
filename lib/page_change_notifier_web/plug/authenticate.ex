defmodule PageChangeNotifierWeb.Plug.Authenticate do
  import Plug.Conn
  import PageChangeNotifierWeb.Router.Helpers
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _default) do
    case conn |> current_user_id do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in")
        |> redirect(to: session_path(conn, :new))
        |> halt

      current_user_id ->
        user = PageChangeNotifier.Repo.get(PageChangeNotifier.User, current_user_id)
        conn |> assign(:current_user, user)
    end
  end

  defp current_user_id(conn) do
    case Mix.env() do
      :test ->
        conn.private[:authenticated_current_user_id]

      _ ->
        conn |> fetch_session |> get_session(:current_user_id)
    end
  end
end
