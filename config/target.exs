import Config

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Use shoehorn to start the main application. See the shoehorn
# library documentation for more control in ordering how OTP
# applications are started and handling failures.

config :shoehorn, init: [:nerves_runtime, :nerves_pack]

# Erlinit can be configured without a rootfs_overlay. See
# https://github.com/nerves-project/erlinit/ for more information on
# configuring erlinit.

# Advance the system clock on devices without real-time clocks.
config :nerves, :erlinit, update_clock: true

# Configure the device for SSH IEx prompt access and firmware updates
#
# * See https://hexdocs.pm/nerves_ssh/readme.html for general SSH configuration
# * See https://hexdocs.pm/ssh_subsystem_fwup/readme.html for firmware updates

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure the network using vintage_net
# See https://github.com/nerves-networking/vintage_net for more information
config :vintage_net,
  regulatory_domain: "US",
  config: [
    {"usb0", %{type: VintageNetDirect}},
    {"eth0",
     %{
       type: VintageNetEthernet,
       ipv4: %{method: :dhcp}
     }},
    {"wlan0", %{type: VintageNetWiFi}}
  ]

config :mdns_lite,
  # The `hosts` key specifies what hostnames mdns_lite advertises.  `:hostname`
  # advertises the device's hostname.local. For the official Nerves systems, this
  # is "nerves-<4 digit serial#>.local".  The `"nerves"` host causes mdns_lite
  # to advertise "nerves.local" for convenience. If more than one Nerves device
  # is on the network, it is recommended to delete "nerves" from the list
  # because otherwise any of the devices may respond to nerves.local leading to
  # unpredictable behavior.

  hosts: [:hostname, "nerves"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]

# Enable mdns lite dns bridging
config :mdns_lite,
  dns_bridge_enabled: true,
  dns_bridge_ip: {127, 0, 0, 53},
  dns_bridge_port: 53,
  dns_bridge_recursive: true

config :vintage_net,
  additional_name_servers: [{127, 0, 0, 53}]

inky_displays = %{
  :impression_5_7 => %{
    size: {600, 448},
    driver: [
      module: ScenicDriverInky,
      opts: [
        type: :impression_5_7,
        color_low: 120,
        dithering: false,
        interval: 2_000
      ]
    ]
  },
  :impression_7_3 => %{
    size: {800, 480},
    driver: [
      module: ScenicDriverInky,
      opts: [
        type: :impression_7_3,
        color_low: 120,
        dithering: false,
        interval: 2_000
      ]
    ]
  },
  :phat_ssd1608 => %{
    size: {250, 122},
    driver: [
      module: ScenicDriverInky,
      opts: [
        type: :phat_ssd1608,
        accent: :red,
        opts: %{
          border: :black
        }
      ]
    ]
  }
}

display = inky_displays.impression_7_3

config :inky_tester, :viewport,
  name: :main_viewport,
  size: display.size,
  theme: :dark,
  # default_scene: InkyTester.Scene.Home,
  default_scene: Dash.Scene.Home,
  drivers: [
    [
      module: Scenic.Driver.Local
    ],
    display.driver
  ]

config :inky_tester, start_button_handler: true

config :mahaul, mix_env: Mix.env()

config :dash, Dash.QuantumScheduler,
  jobs: [
    {"29,59 5-22 * * *", {Dash.Weather.Server, :update_weather, []}},
    {"*/1 * * * *", {Dash.PomodoroServer, :refresh, []}},
    {"*/30 5-22 * * *", {Dash.Scene.Home, :refresh, []}},
    {"0 4 * * *", {Dash.Scene.Home, :switch_quotes, []}}
  ]

config :dash, wait_for_network: true
config :dash, ecto_repos: [Dash.Repo]
config :dash, gh_stats_base_url: "http://192.168.1.2:4004"

config :dash, Dash.Repo,
  database: "/data/dash_database.db",
  migration_primary_key: [type: :binary_id],
  journal_mode: :wal,
  cache_size: -64_000,
  temp_store: :memory,
  pool_size: 1

config :dash, locations: []

case Mix.target() do
  :rpi0 ->
    config :nerves, :firmware, fwup_conf: "config/rpi0/fwup.conf"

  :rpi3 ->
    config :nerves, :firmware, fwup_conf: "config/rpi3/fwup.conf"

  _ ->
    nil
end

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"
