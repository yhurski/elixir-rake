defmodule ElixirTest.Dependency.FormatterTest do
  use ExUnit.Case, async: true

  doctest ElixirRake

  import ElixirRake.Dependency.Formatter

  test "empty dependency list expands to empty list" do
    assert expand_each([], TaskMod) == []
  end

  test "[:dep] dependency expands to [{task_module, :dep, []}]" do
    assert expand_each([:dep], TaskMod) == [{TaskMod, :dep, []}]
  end

  test "[[:dep]] dependency expands to [{task_module, :dep, []}]" do
    assert expand_each([:dep], TaskMod) == [{TaskMod, :dep, []}]
  end

  test "[{:dep}] dependency expands to [{task_module, :dep, []}]" do
    # IO.inspect expand_each([[{:dep, :dep2}]], TaskMod)
    assert expand_each([:dep], TaskMod) == [{TaskMod, :dep, []}]
  end

  test "[[{:dep}]] dependency expands to [{task_module, :dep, []}]" do
    # IO.inspect expand_each([[{:dep, :dep2}]], TaskMod)
    assert expand_each([:dep], TaskMod) == [{TaskMod, :dep, []}]
  end

  test "[{:dep, :dep2, :dep3}] raises FunctionClauseError" do
    assert_raise FunctionClauseError, fn -> expand_each([{:dep, :dep2, :dep3}], TaskMod) end
  end

  test "[[{:dep, :dep2, :dep3}]] raises FunctionClauseError" do
    assert_raise FunctionClauseError, fn -> expand_each([[{:dep, :dep2, :dep3}]], TaskMod) end
  end

  test "[:dep1, :dep2, :dep3] dependency expands to \
        [{task_module, :dep1, []}, {task_module, :dep2, []}, {task_module, :dep3, []}]" do
    deps = [:dep1, :dep2, :dep3]

    result = [
      {TaskMod, :dep1, []},
      {TaskMod, :dep2, []},
      {TaskMod, :dep3, []}
    ]

    assert expand_each(deps, TaskMod) == result
  end

  test "[[:dep1], [:dep2], [:dep3]] dependency expands to \
        [{task_module, :dep1, []}, {task_module, :dep2, []}, {task_module, :dep3, []}]" do
    deps = [[:dep1], [:dep2], [:dep3]]

    result = [
      {TaskMod, :dep1, []},
      {TaskMod, :dep2, []},
      {TaskMod, :dep3, []}
    ]

    assert expand_each(deps, TaskMod) == result
  end

  test "[[{:dep1}], [{:dep2}], [{:dep3}]] dependency expands to \
        [{task_module, :dep1, []}, {task_module, :dep2, []}, {task_module, :dep3, []}]" do
    deps = [[{:dep1}], [{:dep2}], [{:dep3}]]

    result = [
      {TaskMod, :dep1, []},
      {TaskMod, :dep2, []},
      {TaskMod, :dep3, []}
    ]

    assert expand_each(deps, TaskMod) == result
  end

  test "[{:dep, []}] dependency expands to [{task_module, :dep, []}]" do
    deps = [{:dep, []}]
    result = [{TaskMod, :dep, []}]

    assert expand_each(deps, TaskMod) == result
  end

  test "[[{:dep, []}]] dependency expands to [{task_module, :dep, []}]" do
    deps = [{:dep, []}]
    result = [{TaskMod, :dep, []}]

    assert expand_each(deps, TaskMod) == result
  end

  test "[{:dep1, []}, {:dep2, []}, {:dep3, []}] dependency expands to \
        [{task_module, :dep1, []}, {task_module, :dep2, []}, {task_module, :dep3, []}]" do
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

    assert expand_each(deps, task_module) == result
  end

  test "[{ext_module1, :dep1}, {ext_module2, :dep2}, {ext_module3, :dep3}] dependency expands to \
        [{ext_module1, :dep1, []}, {ext_module2, :dep2, []}, {ext_module3, :dep3, []}]" do
    task_module = TaskMod
    ext_modules = [ExternalMod1, ExternalMod2, ExternalMod3]
    functions = [:dep1, :dep2, :dep3]

    deps = List.zip([ext_modules, functions])
    result = List.zip([ext_modules, functions, List.duplicate([], 3)])

    assert expand_each(deps, task_module) == result
  end

  test "[{ext_module, :dep, []}] dependency expands to [{ext_module, :dep, []}]" do
    task_module = TaskMod
    ext_module = ExternalMod
    deps = [{ext_module, :dep, []}]
    result = [{ext_module, :dep, []}]

    assert expand_each(deps, task_module) == result
  end

  test "[[{ext_module, :dep, []}]] dependency expands to [{ext_module, :dep, []}]" do
    task_module = TaskMod
    ext_module = ExternalMod
    deps = [[{ext_module, :dep, []}]]
    result = [{ext_module, :dep, []}]

    assert expand_each(deps, task_module) == result
  end

  test "[{ext_module, :dep, [:arg1, :arg2, :arg3]}] dependency expands to \
        [{ext_module, :dep, [:arg1, :arg2, :arg3]}]" do
    task_module = TaskMod
    ext_module = ExternalMod
    deps = [{ext_module, :dep, [:arg1, :arg2, :arg3]}]
    result = [{ext_module, :dep, [:arg1, :arg2, :arg3]}]

    assert expand_each(deps, task_module) == result
  end

  test "[[{ext_module, :dep, [:arg1, :arg2, :arg3]}]] dependency expands to \
        [{ext_module, :dep, [:arg1, :arg2, :arg3]}]" do
    task_module = TaskMod
    ext_module = ExternalMod
    deps = [[{ext_module, :dep, [:arg1, :arg2, :arg3]}]]
    result = [{ext_module, :dep, [:arg1, :arg2, :arg3]}]

    assert expand_each(deps, task_module) == result
  end

  test "[{ext_module1, :dep1, [:arg1]}, {ext_module2, :dep2, [:arg2, :arg3]}] dependency expands to \
        [{ext_module1, :dep1, [:arg1]}, {ext_module2, :dep2, [:arg2, :arg3]}]" do
    task_module = TaskMod
    ext_modules = [ExternalMod1, ExternalMod2]
    funcs = [:dep1, :dep2]
    args = [[:arg1], [:arg2, :arg3]]

    deps = List.zip([ext_modules, funcs, args])
    result = List.zip([ext_modules, funcs, args])

    assert expand_each(deps, task_module) == result
  end

  test "[[{ext_module1, :dep1, [:arg1]}], [{ext_module2, :dep2, [:arg2, :arg3]}]] dependency expands to \
        [{ext_module1, :dep1, [:arg1]}, {ext_module2, :dep2, [:arg2, :arg3]}]" do
    task_module = TaskMod
    ext_modules = [ExternalMod1, ExternalMod2]
    funcs = [:dep1, :dep2]
    args = [[:arg1], [:arg2, :arg3]]

    deps =
      List.zip([ext_modules, funcs, args])
      |> Enum.map(&List.wrap(&1))

    result = List.zip([ext_modules, funcs, args])

    assert expand_each(deps, task_module) == result
  end

  test "[:dep1, {ext_module, :dep1}] dependency expands to \
        [{task_module, :dep1, []}, {ext_module, :dep1, []}]" do
    task_module = TaskMod
    ext_module = ExternalMod

    deps = [:dep1, {ext_module, :dep1}]
    result = [{task_module, :dep1, []}, {ext_module, :dep1, []}]

    assert expand_each(deps, task_module) == result
  end

  test "[{ext_module1, :dep1}, :dep1, :dep2, {:dep3, [:arg1]}, {ext_module2, :dep4}] dependency expands to \
        [{ext_module1, :dep1, []}, {task_module, :dep1, []}, \
        {task_module, :dep2, []}, {task_module, :dep3, [:arg1]}, {ext_module2, :dep4, []}]" do
    task_module = TaskMod
    [ext_module1, ext_module2] = [ExternalMod1, ExternalMod2]

    deps = [
      {ext_module1, :dep1},
      :dep1,
      :dep2,
      {:dep3, [:arg1]},
      {ext_module2, :dep4}
    ]

    result = [
      {ext_module1, :dep1, []},
      {task_module, :dep1, []},
      {task_module, :dep2, []},
      {task_module, :dep3, [:arg1]},
      {ext_module2, :dep4, []}
    ]

    assert expand_each(deps, task_module) == result
  end

  test "[[{ext_module1, :dep1}], [:dep2], [{:dep3, [:arg1]}], [{ext_module2, :dep4}]] dependency expands to \
        [{ext_module1, :dep1, []}, {task_module, :dep1, []},\
        {task_module, :dep2, []}, {task_module, :dep3, [:arg1]}, {ext_module2, :dep4, []}]" do
    task_module = TaskMod
    [ext_module1, ext_module2] = [ExternalMod1, ExternalMod2]

    deps = [
      [{ext_module1, :dep1}],
      [:dep2],
      [{:dep3, [:arg1]}],
      [{ext_module2, :dep4}]
    ]

    result = [
      {ext_module1, :dep1, []},
      {task_module, :dep2, []},
      {task_module, :dep3, [:arg1]},
      {ext_module2, :dep4, []}
    ]

    assert expand_each(deps, task_module) == result
  end
end
