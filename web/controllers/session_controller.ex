defmodule PageChangeNotifier.SessionController do
  use PageChangeNotifier.Web, :controller
  alias PageChangeNotifier.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    render conn, changeset: User.changeset(%User{})
  end

  def create(conn, %{"user" => user_params}) do
    if is_nil(user_params["username"]) do
      conn
        |> put_flash(:error, 'Please enter a username.')
        |> render "new.html", changeset: User.changeset(%User{})
    else
      user = Repo.get_by(User, username: user_params["username"])
      if is_nil(user) do
        user = create_user(user_params["username"])
        conn
          |> put_session(:current_user, user)
          |> put_flash(:info, 'User created')
          |> redirect(to: user_path(conn, :edit, user))
      else
        conn
          |> put_session(:current_user, user)
          |> put_flash(:info, 'You are now signed in.')
          |> redirect(to: page_path(conn, :index))
      end
    end
  end

  def delete(conn, _) do
    delete_session(conn, :current_user)
      |> put_flash(:info, 'You have been logged out')
      |> redirect(to: session_path(conn, :new))
  end

  # create user
  defp sign_in(user, conn, username) when is_nil(user) do
    create_user(username)
      |> sign_in(conn, username)
  end

  defp sign_in(user, conn, _username) when is_map(user) do
    conn
      |> put_session(:current_user, user)
      |> put_flash(:info, 'You are now signed in.')
      |> redirect(to: page_path(conn, :index))
  end

  defp create_user(username) do
    Repo.insert! %User{ username: username }
  end
end
