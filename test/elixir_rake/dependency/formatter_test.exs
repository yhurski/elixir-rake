defmodule ElixirTest.Dependency.FormatterTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  import ElixirRake.Dependency.Formatter

  test "empty dependency list expands to empty list" do
    assert expand_each([], TaskMod) == []
  end

  test "[:dep] dependency expands to [{module, atom, []}]" do
    assert expand_each([:dep], TaskMod) == [{TaskMod, :dep, []}]
  end

  test "[{:dep, []}] dependency expands to [{module, atom, []}]" do
    assert expand_each([{:dep, []}], TaskMod) == [{TaskMod, :dep, []}]
  end
end
