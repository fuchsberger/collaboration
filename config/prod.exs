use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :collaboration, Collaboration.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "http", host: "192.168.30.103", port: 57095],
  cache_static_manifest: "priv/static/manifest.json",
  # configuration for the Distillery release
  root: ".",
  server: true,
  version: Mix.Project.config[:version]

config :collaboration, Collaboration.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE_COLLABOATION")

config :collaboration, Collaboration.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_DATABASE_COLLABORATION"),
  hostname: System.get_env("DB_HOSTNAME"),
  pool_size: 20

# This line appears further down. Do not forget to uncomment it!
config :phoenix, :serve_endpoints, true

# Do not print debug messages in production
config :logger, level: :info


