# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :todo_backend,
  ecto_repos: [TodoBackend.Repo]

# Configures the endpoint
config :todo_backend, TodoBackendWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: TodoBackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TodoBackend.PubSub,
  live_view: [signing_salt: "aDOsFMfo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :todo_backend, TodoBackend.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: TodoBackend.EventStore
  ],
  pubsub: :local,
  registry: :local

config :commanded_ecto_projections, repo: TodoBackend.Repo

config :todo_backend, event_stores: [TodoBackend.EventStore]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
