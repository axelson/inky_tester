defmodule InkyTester.StartupServer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_) do
    # Hacks!
    sleep_time = Application.get_env(:inky_tester, :startup_sleep, 0)
    Process.sleep(sleep_time)
    :persistent_term.put(:scenic_driver_inky_ready, true)

    {:ok, []}
  end
end
