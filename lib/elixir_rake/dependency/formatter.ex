defmodule ElixirRake.Dependency.Formatter do
  def expand_each(deps_list, task_module), do: expand_each(deps_list, [], task_module)
  def expand_each([], expanded_deps_list, _task_module), do: expanded_deps_list
  def expand_each([h | t], expanded_deps_list, task_module) do
    [expand(task_module, h) | expand_each(t, expanded_deps_list, task_module)]
  end

  def expand([]), do: []
  def expand(mod, list) when is_list(list), do: expand_each(list, mod)
  def expand(mod, func) when is_atom(func) do # depends_on(:ping)
    {mod, func, []}
  end
  def expand(mod, {func, args}) when is_atom(func) and is_list(args) do # depends_on([{:ping, ["google.com"]}])
    {mod, func, args}
  end
  def expand(_mod, {ext_mode, func}) when is_atom(ext_mode) and is_atom(func) do # depends_on([{Mod, :ping}])
    {ext_mode, func, []}
  end
  def expand(_mod, {ext_mode, func, args}) # depends_on([{Mod, :ping, ["google.com"]}])
    when is_atom(ext_mode) and is_atom(func) and is_list(args) do
    {ext_mode, func, []}
  end
end
