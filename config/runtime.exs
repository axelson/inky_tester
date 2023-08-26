import Config

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

  path = "/mnt/arch_linux/home/jason/dev/inky_impression_livebook/.target.secret.exs"
  # path = "/mnt/arch_linux/home/jason/dev/inky_impression_livebook/.target.public.exs"
  if File.exists?(path) do
    Code.require_file(path)
  end
end
