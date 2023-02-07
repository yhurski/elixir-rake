defmodule ElixirRake.Dependency.Flattener do
  @moduledoc """
  Flattens nested dependencies. E.g. given a dependency list looking like this:
  [{{:mod1, :a, 0}, [{{:mod2, :b, [1,2]}, [{:mod3, :c, [1,2]}]} ]}]
  this module returns the following:
  [{:mod3, :c, [1,2]}, {:mod2, :b, [1,2]}, {:mod1, :a, 0}]
  i.e. the flattened list in reverse order, ready to be sequentially executed
  """

  def flatten(nested_deps), do: flatten(nested_deps, [])

  def flatten([], flat_deps), do: flat_deps
  def flatten([{mod, func, args} | t], flat_deps) do
    flatten(t, [{mod, func, args} | flat_deps])
  end
  def flatten([{{mod, func, args}, subdeps}|t], flat_deps) do
    flatten(t, flatten(subdeps, [{mod, func, args} | flat_deps]))
  end
end
