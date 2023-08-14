import Config

inky_displays = %{
  :impression_7_3 => %{
    size: {800, 480},
   },
  :phat_ssd1608 => %{
    size: {250, 122},
   }
}

display = inky_displays.impression_7_3

config :inky_tester, :viewport,
  size: display.size,
  theme: :light,
  default_scene: InkyTester.Scene.Home,
  drivers: [
    [
      module: Scenic.Driver.Local,
      window: [title: "inky_tester"],
      on_close: :stop_system
    ]
  ]

case Mix.env() do
  :dev ->
    config :exsync,
      reload_timeout: 150,
      reload_callback: {ScenicLiveReload, :reload_current_scenes, []}

  _ ->
    nil
end

config :nerves_runtime,
  kv_backend:
    {Nerves.Runtime.KVBackend.InMemory,
     contents: %{
       # The KV store on Nerves systems is typically read from UBoot-env, but
       # this allows us to use a pre-populated InMemory store when running on
       # host for development and testing.
       #
       # https://hexdocs.pm/nerves_runtime/readme.html#using-nerves_runtime-in-tests
       # https://hexdocs.pm/nerves_runtime/readme.html#nerves-system-and-firmware-metadata

       "nerves_fw_active" => "a",
       "a.nerves_fw_architecture" => "generic",
       "a.nerves_fw_description" => "N/A",
       "a.nerves_fw_platform" => "host",
       "a.nerves_fw_version" => "0.0.0"
     }}

config :vintage_net,
  resolvconf: "/dev/null",
  persistence: VintageNet.Persistence.Null

config :dash, Dash.QuantumScheduler,
  jobs: [
    {"*/30 * * * *", {Dash.Weather.Server, :update_weather, []}}
  ]

config :dash, wait_for_network: true
config :dash, ecto_repos: [Dash.Repo]

config :dash, Dash.Repo,
  database: "priv/dash_database.db",
  migration_primary_key: [type: :binary_id],
  journal_mode: :wal,
  cache_size: -64_000,
  temp_store: :memory,
  pool_size: 1

config :dash, locations: []

