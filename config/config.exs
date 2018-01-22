# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :page_change_notifier, ecto_repos: [PageChangeNotifier.Repo]

# Configures the endpoint
config :page_change_notifier, PageChangeNotifierWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mzwZlWfGB2PwXmjZhbVd7xAvdPccSqoOHXdXybK25ax7f17HyamgyIiyWnmTIe+X",
  render_errors: [view: PageChangeNotifierWeb.ErrorView, accepts: ~w(html json)],
  mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
  mailgun_key: System.get_env("MAILGUN_API_KEY"),
  pubsub: [name: PageChangeNotifier.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :airbrake,
  api_key: System.get_env("AIRBRAKE_API_KEY"),
  project_id: System.get_env("AIRBRAKE_PROJECT_ID")

config :nadia, token: System.get_env("TELEGRAM_BOT_TOKEN")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
