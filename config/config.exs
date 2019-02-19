# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :carListing,
  ecto_repos: [CarListing.Repo]

# Configures the endpoint
config :carListing, CarListingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ACnL0pZjFtGdGsjCq5n3AYqEobPaHG4gVaHWY8dwkU4r0BlQ9SX4xlrVLqTKNY9s",
  render_errors: [view: CarListingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CarListing.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
