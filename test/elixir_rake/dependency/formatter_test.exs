defmodule ElixirTest.Dependency.FormatterTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  import ElixirRake.Dependency.Formatter

  # setup_all do
  #   module = Asdf

  #   :ok
  # end

  test "empty dependency list expands to empty list" do
    assert expand_each([], TaskMod) == []
  end

  test "[:dep] dependency expands to [{module, :dep, []}]" do
    assert expand_each([:dep], TaskMod) == [{TaskMod, :dep, []}]
  end

  test "[:dep1, :dep2, :dep3] dependency expands to \
        [{module, :dep1, []}, {module, :dep2, []}, {module, :dep3, []}]" do
    deps = [:dep1, :dep2, :dep3]

    result = [
      {TaskMod, :dep1, []},
      {TaskMod, :dep2, []},
      {TaskMod, :dep3, []}
    ]

    assert expand_each(deps, TaskMod) == result
  end

  test "[{:dep, []}] dependency expands to [{module, :dep, []}]" do
    deps = [{:dep, []}]
    result = [{TaskMod, :dep, []}]

    assert expand_each(deps, TaskMod) == result
  end

  test "[{:dep1, []}, {:dep2, []}, {:dep3, []}] dependency expands to \
        [{module, :dep1, []}, {module, :dep2, []}, {module, :dep3, []}]" do
    module = TaskMod
    deps = [{:dep1, []}, {:dep2, []}, {:dep3, []}]
    result = [{module, :dep1, []}, {module, :dep2, []}, {module, :dep3, []}]

    assert expand_each(deps, module) == result
  end

  test "[{ext_module, :dep}] dependency expands to [{ext_module, :dep, []}]" do
    task_module = TaskMod
    ext_module = ExternalMod
    deps = [{ext_module, :dep}]
    result = [{ext_module, :dep, []}]

    assert expand_each(deps, TaskMod) == result
  end
end
