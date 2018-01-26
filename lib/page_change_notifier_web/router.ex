defmodule PageChangeNotifierWeb.Router do
  use PageChangeNotifierWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PageChangeNotifierWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", SearchAgentController, :index)
    get("/login", SessionController, :new)
    post("/login", SessionController, :create)
    get("/logout", SessionController, :delete)
    get("/search", SearchController, :search)
    resources("/results", ResultController)
    resources("/users", UserController)
    resources("/search_agents", SearchAgentController)
  end

  scope "/telegram", PageChangeNotifierWeb do
    pipe_through(:api)
    post("/webhook", TelegramController, :webhook)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PageChangeNotifierWeb do
  #   pipe_through :api
  # end
end
