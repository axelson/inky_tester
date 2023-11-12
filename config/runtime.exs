import Config

timezone = Application.fetch_env!(:dash, :timezone)

if config_target() == :host do
  config :dash,
    locations:
      List.duplicate(
        [
          %Dash.Location{
            name: "José",
            location_name: "Kraków, Poland",
            latlon: "50.061,19.937",
            tz: "Europe/Warsaw",
            start_time: ~T[09:00:00],
            partial_finish_time: ~T[18:00:00],
            finish_time: ~T[23:00:00],
            gh_login: "axelson"
          },
          %Dash.Location{
            name: "Joe",
            location_name: "Madrid, Spain",
            latlon: "41.383,2.177",
            tz: "Europe/Madrid",
            start_time: ~T[09:00:00],
            partial_finish_time: ~T[18:00:00],
            finish_time: ~T[23:00:00],
            gh_login: "axelson"
          }
        ],
        3
      )
      |> List.flatten()

  config :dash, Dash.QuantumScheduler,
    timezone: timezone,
    jobs: [
      # Disable the weather server when not using/testing to save API calls
      # Note: on startup the weather is fetched once already
      # {"*/30 * * * *", {Dash.Weather.Server, :update_weather, []}}
      # {"*/1 * * * *", {Dash.Scene.Home, :refresh, []}},
      {"*/1 5-22 * * *", {Dash.Scene.Home, :refresh, []}},
      {"*/1 * * * *", {Dash.PomodoroServer, :refresh, []}}
    ]

  path = Path.join([__DIR__, "..", ".target.secret.exs"])
  # path = Path.join([__DIR__, "..", ".target.public.exs"])

  if File.exists?(path) do
    Code.require_file(path)
  end

  # config :dash, :glamour_shot?, true
end

if config_target() != :host do
  config :dash, Dash.QuantumScheduler,
    timezone: timezone,
    jobs: [
      {"29,59 5-22 * * *", {Dash.Weather.Server, :update_weather, []}},
      {"*/1 * * * *", {Dash.PomodoroServer, :refresh, []}},
      {"*/30 5-22 * * *", {Dash.Scene.Home, :refresh, []}},
      {"0 4 * * *", {Dash.Scene.Home, :switch_quotes, []}}
    ]
end
