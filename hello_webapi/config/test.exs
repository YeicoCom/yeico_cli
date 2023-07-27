import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hello_webapi, HelloWebapiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lFfoxDQrPJVXsA6BX01BDxXj0PoqgpkgE2jlnZATiGteqsDO74bUlIMd1CWLdQ2a",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
