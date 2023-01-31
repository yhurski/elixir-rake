defmodule ElixirTest.DependencyTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  import ElixirRake.Dependency

  test "simple one level flat dependencies" do
    deps = [a: [], b: [], c: []]
    result = [a: [], b: [], c: []]

    assert flatten(deps) == result
  end

  test "returns empty kw list if empty kw list is passed in" do
    assert flatten([]) == []
  end

  test "raises ArgumentError if argument is not a kw list" do
    assert_raise ArgumentError, fn -> flatten([{:a, [:aa1, :aa2]}, :b]) end
  end

  test "simple two level deep dependencies" do
    deps = [
      a: [:kk, :kk2],
      top: [:a, :b],
      top2: [:top]
    ]

    result = [
      a: [:kk, :kk2],
      top: [{:a, [:kk, :kk2]}, :b],
      top2: [top: [{:a, [:kk, :kk2]}, :b]]
    ]

    assert flatten(deps) == result
  end
end
