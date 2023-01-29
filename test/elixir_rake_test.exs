defmodule ElixirRakeTest do
  use ExUnit.Case
  doctest ElixirRake

  test "greets the world" do
    assert ElixirRake.hello() == :world
  end
end
