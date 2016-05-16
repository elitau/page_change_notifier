defmodule PageChangeNotifier.Mixfile do
  use Mix.Project

  ###### HELP
  # On adding deps:
  # mix deps.clean --all
  # mix deps.get
  # mix deps.compile
  #

  def project do
    [app: :page_change_notifier,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {PageChangeNotifier, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :mailgun, :floki,
                    :airbrake_plug, :httpoison, :nadia, :mix]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.0.3"},
      {:phoenix_ecto, "~> 1.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.1"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:poison, "~> 1.5"},
      {:httpoison, "~> 0.8"},
      {:exvcr, github: "parroty/exvcr"},
      {:floki, "~> 0.7"},
      {:mailgun, "~> 0.1.1"},
      {:cowboy, "~> 1.0"},
      {:airbrake_plug, "~> 0.1.0"},
      {:nadia, "~> 0.3"},
      # {:mock,                "~> 0.1.1",  only: :test},
      {:airbrake, git: "https://github.com/elitau/airbrake-elixir.git", override: true}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
