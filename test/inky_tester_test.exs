defmodule InkyTesterTest do
  use ExUnit.Case
  doctest InkyTester

  test "greets the world" do
    assert InkyTester.hello() == :world
  end
end
