# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :wk_job,
  ecto_repos: [WkJob.Repo]

config :wk_job_web,
  ecto_repos: [WkJob.Repo],
  generators: [context_app: :wk_job, binary_id: true]

# Configures the endpoint
config :wk_job_web, WkJobWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2rUg5MPMVI5DnNTI3/yny6CkA9aPlFH+mZBnrW4S5WXgscxKpVKFwypJ/Qz1Y0Xg",
  render_errors: [view: WkJobWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WkJob.PubSub,
  live_view: [signing_salt: "DkVj0lI2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
