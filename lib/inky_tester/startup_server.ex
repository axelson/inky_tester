defmodule InkyTester.StartupServer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_) do
    Process.sleep(3_000)
    :persistent_term.put(:scenic_driver_inky_ready, true)

    {:ok, []}
  end
end
