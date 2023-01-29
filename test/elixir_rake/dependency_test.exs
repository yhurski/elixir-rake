defmodule ElixirTest.DependencyTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  import ElixirRake.Dependency

  test "simple one level flat dependencies" do
    deps = [a: [], b: [], c: []]
    result = [a: [], b: [], c: []]

    assert flatten(deps) == result
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
