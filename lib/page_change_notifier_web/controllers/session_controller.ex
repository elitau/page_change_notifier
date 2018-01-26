defmodule PageChangeNotifierWeb.SessionController do
  use PageChangeNotifierWeb, :controller
  alias PageChangeNotifier.User
  alias PageChangeNotifier.Repo

  plug(:scrub_params, "user" when action in [:create])
  plug(PageChangeNotifierWeb.Plug.Authenticate when action in [:delete])

  def new(conn, _params) do
    conn = assign(conn, :current_user, %User{id: 0})
    render(conn, changeset: User.changeset(%User{}))
  end

  def create(conn, %{"user" => user_params}) do
    if is_nil(user_params["username"]) do
      conn
      |> put_flash(:error, 'Please enter a username.')
      |> render("new.html", changeset: User.changeset(%User{}))
    else
      user = Repo.get_by(User, username: user_params["username"])

      if is_nil(user) do
        user = create_user(user_params["username"])

        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, 'User created')
        |> redirect(to: user_path(conn, :edit, user))
      else
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, 'You are now signed in.')
        |> redirect(to: search_agent_path(conn, :index))
      end
    end
  end

  def delete(conn, _) do
    delete_session(conn, :current_user_id)
    |> put_flash(:info, 'You have been logged out')
    |> redirect(to: session_path(conn, :new))
  end

  defp create_user(username) do
    Repo.insert!(%User{username: username})
  end
end
