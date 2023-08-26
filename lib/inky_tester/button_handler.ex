defmodule InkyTester.ButtonHandler do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(_opts) do
    state = %{}
    {:ok, state}
  end

  @impl GenServer
  def handle_info(%Inky.ImpressionButtons.Event{action: :pressed, name: name}, state) do
    case name do
      :a -> Dash.switch_scene(:home)
      :b -> Dash.switch_scene(:color_test)
      :x -> Dash.switch_scene(:fonts)
      :y -> Dash.Scene.Home.refresh()
    end

    Logger.info("Button pressed! #{inspect(name)}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info("Ignoring msg: #{inspect(msg)}")
    {:noreply, state}
  end
end
