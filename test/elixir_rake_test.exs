defmodule ElixirRakeTest do
  use ExUnit.Case
  doctest ElixirRake

  setup_all do
    defmodule TaskMod1 do
      use ElixirRake
      import ElixirRake

      desc "task1"
      depends_on [:task2, {IO, :puts, ["from IO"]}]
      def task1(), do: IO.puts("test task 1")

      desc "task2"
      def task2(), do: IO.puts("test task 2")
    end

    {:ok, task_mod1: TaskMod1}
  end

  describe "ElixirRake module" do
    test "has __using__ macro" do
      assert macro_exported?(ElixirRake, :__using__, 1)
    end

    test "has __on_definition__ function" do
      assert function_exported?(ElixirRake, :__on_definition__, 6)
    end

    test "has __before_compile__ macro" do
      assert macro_exported?(ElixirRake, :__before_compile__, 1)
    end

    test "has desc macro" do
      assert macro_exported?(ElixirRake, :desc, 1)
    end

    test "has depends_on macro" do
      assert macro_exported?(ElixirRake, :depends_on, 1)
    end
  end

  describe "Task module" do
    test "has __elixir_rake_tasks_deps__/0 function", %{task_mod1: task_mod1} do
      assert function_exported?(task_mod1, :__elixir_rake_tasks_deps__, 0)
    end

    test "has task1/0 in __elixir_rake_tasks_deps__/0 function", %{task_mod1: task_mod1} do
      assert List.keymember?(task_mod1.__elixir_rake_tasks_deps__(), {task_mod1, :task1, 0}, 0)
    end

    test "has task2/0 in __elixir_rake_tasks_deps__/0 function", %{task_mod1: task_mod1} do
      assert List.keymember?(task_mod1.__elixir_rake_tasks_deps__(), {task_mod1, :task2, 0}, 0)
    end

    test "has description for task1/0 in __elixir_rake_tasks_deps__/0 function", %{task_mod1: task_mod1} do
      with item <- List.keyfind(task_mod1.__elixir_rake_tasks_deps__(), {task_mod1, :task1, 0}, 0) do
        assert elem(item, 1) == "task1"
      end
    end

    test "has description for task2/0 in __elixir_rake_tasks_deps__/0 function", %{task_mod1: task_mod1} do
      with item <- List.keyfind(task_mod1.__elixir_rake_tasks_deps__(), {task_mod1, :task2, 0}, 0) do
        assert elem(item, 1) == "task2"
      end
    end

    test "has two deps for task1/0 in __elixir_rake_tasks_deps__/0 function", %{task_mod1: task_mod1} do
      deps = [
        {IO, :puts, ["from IO"]},
        {ElixirRakeTest.TaskMod1, :task2, []}
      ]

      with item <- List.keyfind(task_mod1.__elixir_rake_tasks_deps__(), {task_mod1, :task1, 0}, 0) do
        assert elem(item, 2) == deps
      end
    end

    test "has zero deps for task2/0 in __elixir_rake_tasks_deps__/0 function", %{task_mod1: task_mod1} do
      with item <- List.keyfind(task_mod1.__elixir_rake_tasks_deps__(), {task_mod1, :task2, 0}, 0) do
        assert elem(item, 2) == []
      end
    end

    test "imports desc macro", %{task_mod1: task_mod1} do
      IO.inspect task_mod1.__elixir_rake_tasks_deps__()

      assert task_mod1.task1() == :ok
    end
  end
end
