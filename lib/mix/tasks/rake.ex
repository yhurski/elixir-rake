defmodule Mix.Tasks.Rake do
  use Mix.Task

  @shortdoc """
  Rake for Elixir
  """

  def run([mod | [func | args]]) do
    ElixirRake.Executor.call(mod, func, args)
  end
end
