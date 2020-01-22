use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :page_change_notifier, PageChangeNotifierWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :page_change_notifier, PageChangeNotifier.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PG_USER") || System.get_env("USER"),
  password: System.get_env("PG_PASSWORD") || "",
  database: "page_change_notifier_test",
  hostname: System.get_env("PG_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :exvcr, vcr_cassette_library_dir: "test/fixtures/vcr_cassettes"
