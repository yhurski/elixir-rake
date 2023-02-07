defmodule ElixirTest.Dependency.FlattenerTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  describe "Flattener.flatten/1" do
    import ElixirRake.Dependency.Flattener

    test "returns one item list for no-dependencies list #1" do
      deps = [{{:mod1, :a, [1, 2, 3]}, []}]
      result = [{:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns one item list for no-dependencies list #2" do
      deps = [{:mod1, :a, [1, 2, 3]}]
      result = [{:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns two item list for no-dependencies list #1" do
      deps = [{{:mod1, :a, [1, 2, 3]}, []}, {{:mod2, :b, [:arg1]}, []}]
      result = [{:mod2, :b, [:arg1]}, {:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns two item list for no-dependencies list #2" do
      deps = [{:mod1, :a, [1, 2, 3]}, {:mod2, :b, [:arg1]}]
      result = [{:mod2, :b, [:arg1]}, {:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns two item list for one level dependency list #1" do
      deps = [{{:mod1, :a, [1, 2, 3]}, [{:mod2, :b, []}]}]
      result = [{:mod2, :b, []}, {:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns two item list for one level dependency list #2" do
      deps = [{{:mod1, :a, [1, 2, 3]}, [{{:mod2, :b, []}, []}]}]
      result = [{:mod2, :b, []}, {:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns three item list for one level dependency list #3" do
      deps = [{{:mod1, :a, [1, 2, 3]}, [{:mod2, :b, []}, {:mod3, :c, [:arg1, :arg2]}]}]
      result = [{:mod3, :c, [:arg1, :arg2]}, {:mod2, :b, []}, {:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns three item list for two level dependency list #1" do
      deps = [{{:mod1, :a, [1, 2, 3]}, [{{:mod2, :b, []}, [{:mod3, :c, []}]}]}]
      result = [{:mod3, :c, []}, {:mod2, :b, []}, {:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end

    test "returns four item list for two level dependency list #2" do
      deps = [{{:mod1, :a, [1, 2, 3]}, [{{:mod2, :b, []}, [{:mod3, :c, []}]}]}, {:mod4, :e, []}]
      result = [{:mod4, :e, []}, {:mod3, :c, []}, {:mod2, :b, []}, {:mod1, :a, [1, 2, 3]}]

      assert flatten(deps) == result
    end
  end
end
