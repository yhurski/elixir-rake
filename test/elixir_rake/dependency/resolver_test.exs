defmodule ElixirTest.Dependency.ResolverTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  describe "Resolver.resolve/1" do
    import ElixirRake.Dependency.Resolver

    test "returns empty kw list if empty kw list is passed in" do
      assert resolve([]) == []
    end

    test "raises ArgumentError exception when argument is a map" do
      assert_raise ArgumentError, fn -> resolve(%{}) end
    end

    test "returns empty dependencies for actions with empty dependencies" do
      deps = [{{:mod1, :a, 0}, []}, {{:mod2, :b, 1}, []}, {{:mod3, :c, 3}, []}]
      result = [{{:mod1, :a, 0}, []}, {{:mod2, :b, 1}, []}, {{:mod3, :c, 3}, []}]

      assert resolve(deps) == result
    end

    test "returns dependencies for one level dependencies #1" do
      deps = [
        {{:mod1, :a, 0}, [{:mod2, :b, [1,2]}, {:mod3, :c, [1,2]}]}
      ]
      result = [
        {{:mod1, :a, 0}, [{:mod2, :b, [1,2]}, {:mod3, :c, [1,2]}]}
      ]

      assert resolve(deps) == result
    end

    test "returns dependencies for one level dependencies #2" do
      deps = [
        {{:mod1, :a, 2}, [{:mod2, :kk, [1, 2]}, {:mod2, :kk2, ["a", "b"]}]},
        {{:mod1, :top, 0}, [{:mod1, :a, ["h", "w"]}, {:mod1, :b, []}]},
        {{:mod1, :top2, 4}, [{:mod1, :top, []}, {:mod1, :b, []}]}
      ]

      result = [
        {{:mod1, :a, 2}, [{:mod2, :kk, [1, 2]}, {:mod2, :kk2, ["a", "b"]}]},
        {{:mod1, :top, 0},
         [
           {{:mod1, :a, ["h", "w"]}, [{:mod2, :kk, [1, 2]}, {:mod2, :kk2, ["a", "b"]}]},
           {:mod1, :b, []}
         ]},
        {{:mod1, :top2, 4},
         [
           {{:mod1, :top, []},
            [
              {{:mod1, :a, ["h", "w"]}, [{:mod2, :kk, [1, 2]}, {:mod2, :kk2, ["a", "b"]}]},
              {:mod1, :b, []}
            ]},
           {:mod1, :b, []}
         ]}
      ]

      assert resolve(deps) == result
    end

    test "returns dependencies for one level dependencies with empty dependencies list for second level" do
      deps = [
        {{:mod1, :a, 0}, [{{:mod2, :b, [1,2]}, []}, {{:mod3, :c, [1,2]}, []}]}
      ]
      result = [
        {{:mod1, :a, 0}, [{{:mod2, :b, [1,2]}, []}, {{:mod3, :c, [1,2]}, []}]}
      ]

      assert resolve(deps) == result
    end

    test "returns dependencies for two level dependencies" do
      deps = [
        {{:mod1, :a, 0}, [{{:mod2, :b, [1,2]}, [{:mod3, :c, [1,2]}]} ]}
      ]
      result = [
        {{:mod1, :a, 0}, [{{:mod2, :b, [1,2]}, [{:mod3, :c, [1,2]}]} ]}
      ]

      assert resolve(deps) == result
    end

    test "raises ElixirRake.Dependency.Resolver exception for a circular dependency" do
      deps = [
        {{:mod1, :a, 0}, [{:mod2, :b, []}]},
        {{:mod2, :b, 0}, [{:mod1, :a, []}]}
      ]

      assert_raise ElixirRake.Dependency.Resolver, fn -> resolve(deps) end
    end
  end
end
