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
      [
        {Scenic, [viewport_config]}
      ] ++ children(target())

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
    [
      # Children for all targets except host
      # Starts a worker by calling: InkyTester.Worker.start_link(arg)
      # {InkyTester.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:inky_tester, :target)
  end
end
