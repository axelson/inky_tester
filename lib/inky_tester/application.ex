defmodule InkyTester.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InkyTester.Supervisor]
    viewport_config = Application.get_env(:inky_tester, :viewport)

    children =
      ([
         if viewport_config do
           {Scenic, [viewport_config]}
         else
           []
         end,
         start_button_handler(),
         InkyTester.StartupServer
       ] ++ children(target()))
      |> List.flatten()

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: InkyTester.Worker.start_link(arg)
      # {InkyTester.Worker, arg},
    ]
  end

  def children(_target) do
    []
  end

  def target() do
    Application.get_env(:inky_tester, :target)
  end

  defp start_button_handler do
    if Application.fetch_env!(:inky_tester, :start_button_handler) do
      [
        InkyTester.ButtonHandler,
        {Inky.ImpressionButtons, handler: InkyTester.ButtonHandler}
      ]
    else
      []
    end
  end
end
