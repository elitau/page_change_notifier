use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :page_change_notifier, PageChangeNotifierWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :wallaby, driver: Wallaby.Experimental.Chrome
# Configure your database
config :page_change_notifier, PageChangeNotifier.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "page_change_notifier_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
