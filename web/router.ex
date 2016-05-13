defmodule PageChangeNotifier.Router do
  use PageChangeNotifier.Web, :router
  use AirbrakePlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug PageChangeNotifier.Plug.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PageChangeNotifier do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login",  SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    get "/search", SearchController, :search
    resources "/results", ResultController
    resources "/users", UserController
    resources "/search_agents", SearchAgentController
  end

  scope "/telegram", PageChangeNotifier do
    pipe_through :api
    post "/webhook", TelegramController, :webhook
  end

  # Other scopes may use custom stacks.
  # scope "/api", PageChangeNotifier do
  #   pipe_through :api
  # end
end
