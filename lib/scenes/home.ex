defmodule InkyTester.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph

  import Scenic.Primitives
  # import Scenic.Components

  @text_size 24

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(scene, _param, _opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input
    {width, height} = scene.viewport.size

    # show the version of scenic and the glfw driver
    scenic_ver = Application.spec(:scenic, :vsn) |> to_string()
    driver_ver = Application.spec(:scenic_driver_local, :vsn) |> to_string()

    info = "scenic: v#{scenic_ver}\ndriver_local: v#{driver_ver}"

    date_time_str = NaiveDateTime.utc_now() |> Calendar.strftime("%Y-%m-%d %H:%M")

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> add_specs_to_graph([
        text_spec(info, translate: {5, 30}),
        text_spec("time: #{date_time_str}", translate: {5, 100}),
        rect_spec({width, height})
      ])

    scene = push_graph(scene, graph)

    {:ok, scene}
  end

  def handle_input(event, _context, scene) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, scene}
  end
end
