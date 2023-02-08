defmodule ElixirTest.Dependency.RunnerTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  setup_all do
    defmodule DepMod1 do
      def raise_exception(type, msg), do: raise type, msg
    end

    {:ok, dep_mod1: DepMod1}
  end

  describe "Runner.run/2" do
    import ElixirRake.Dependency.Runner

    test "returns :ok for empty dependency list" do
      assert run([]) == :ok
    end

    test "executes one item dependency and returns result" do
      deps = [{Kernel, :+, [1, 2]}]

      assert run(deps) == 3
    end

    test "throws an exception outside of dependency chain", %{dep_mod1: dep_mod1} do
      deps = [
        {List, :duplicate, [[1], 1]},
        {dep_mod1, :raise_exception, [ArgumentError, "test"]},
        {List, :duplicate, [[2], 1]}
      ]

      assert_raise ArgumentError, fn -> run(deps) end
    end
  end
end
