defmodule ElixirRake.Dependency.Runner do
  @moduledoc """
  Executes dependencies given as a list of three element tuples
  """

  def run({mod, func, args}), do: apply(mod, func, args)

  def run(deps, last_result \\ :ok)
  def run([], last_result), do: last_result

  def run([h | t], _last_result) do
    run(t, run(h))
  end
end
