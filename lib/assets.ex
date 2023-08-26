defmodule InkyTester.Assets do
  use Scenic.Assets.Static,
    otp_app: :inky_tester,
    alias: Dash.Assets.alias(),
    sources: [
      "assets",
      {:dash, Dash.Assets.asset_path()},
      # {:dash, "deps/dash/assets"},
      {:scenic, "deps/scenic/assets"}
    ]
end
