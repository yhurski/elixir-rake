defmodule ElixirRake.Dependency.Formatter do
  def expand_each(deps_list, task_module), do: expand_each(deps_list, [], task_module)

  defp expand_each([], expanded_deps_list, _task_module) do
    List.flatten(expanded_deps_list) |> Enum.reverse()
  end

  defp expand_each([h | t], expanded_deps_list, task_module) do
    expand_each(t, [expand(task_module, h) | expanded_deps_list], task_module)
  end

  defp expand(mod, list) when is_list(list), do: expand_each(list, mod)
  # depends_on({:ping})
  defp expand(mod, {func}) when is_atom(func) do
    expand(mod, func)
  end

  # depends_on(:ping)
  defp expand(mod, func) when is_atom(func) do
    {mod, func, []}
  end

  # depends_on([{:ping, ["google.com"]}])
  defp expand(mod, {func, args}) when is_atom(func) and is_list(args) do
    {mod, func, args}
  end

  # depends_on([{Mod, :ping}])
  defp expand(_mod, {ext_mode, func}) when is_atom(ext_mode) and is_atom(func) do
    {ext_mode, func, []}
  end

  # depends_on([{Mod, :ping, ["google.com"]}])
  defp expand(_mod, {ext_mode, func, args})
       when is_atom(ext_mode) and is_atom(func) and is_list(args) do
    {ext_mode, func, args}
  end
end
