defmodule ElixirRake.Executor do
  import String, only: [to_existing_atom: 1, to_atom: 1, to_integer: 1, capitalize: 1]

  def sum(a, b) do
    a + b
  end

  def call(mod, name, args) do
    apply(
      Module.safe_concat([Elixir, capitalize(mod)]),
      to_atom(name),
      Enum.map(args, &to_integer(&1))
    )
    |> IO.inspect()
  end
end
