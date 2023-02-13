defmodule ElixirRake.TaskModuleHelpers do
  def elixir_rake_help(mod) do
    IO.puts("Available tasks in #{__MODULE__} module:")
    # Enum.each(unquote(actions), &IO.puts("\t#{elem(&1, 0)} - #{elem(&1, 1)}"))
    Enum.map(mod.__elixir_rake_tasks_deps__(), fn
      {task, desc, []} -> "\t#{to_string(task)} - #{desc}"
      {task, desc, deps} -> "\t#{to_string(task)} - #{desc}, depends on: #{dependencies_to_string(deps)}"
    end)
    |> IO.puts
  end

  # def actions(), do: ElixirRake.Dependency.Formatter.expand_each(unquote(Macro.escape(actions)), unquote(env.module))

  defp dependencies_to_string(deps), do: dependencies_to_string(deps, [])
  defp dependencies_to_string([], print_forms), do: Enum.reverse(print_forms) |> Enum.join(", ")
  defp dependencies_to_string([h|t], print_forms), do: dependencies_to_string(t, [dependency_to_string(h) | print_forms])
  defp dependency_to_string({mod, func, args}), do: to_string(mod) <> "." <> to_string(func) <> "/" <> to_string(length(args))
end
