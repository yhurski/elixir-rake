defmodule ElixirRakeTest do
  use ExUnit.Case
  doctest ElixirRake

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
    setup do
      defmodule TaskMod do
        use ElixirRake
        import ElixirRake
      end

      {:ok, task_mod: TaskMod}
    end

    test "", %{task_mod: task_mod} do
      # IO.inspect context
      assert ElixirRake.hello() == :world
    end
  end
end
