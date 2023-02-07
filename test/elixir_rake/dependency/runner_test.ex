defmodule ElixirTest.Dependency.RunnerTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  describe "Runner.run/2" do
    import ElixirRake.Dependency.Runner

    test "returns :ok for empty dependency list" do
      assert run([]) == :ok
    end

    test "executes one item dependency and returns result" do
      deps = [{Kernel, :+, [1, 2]}]

      assert run(deps) == 3
    end
  end
end
