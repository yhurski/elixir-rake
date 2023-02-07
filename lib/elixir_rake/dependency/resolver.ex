defmodule ElixirRake.Dependency.Resolver do
  @max_traversal_level 128

  defexception message: """
               Max dependency depth level was exceeded (max level allowed is #{@max_traversal_level}). \
               Probably, you've got a circular dependency.
               """

  def resolve([]), do: []

  def resolve(deps) when is_list(deps), do: resolve(deps, deps)
  def resolve(_deps), do: raise ArgumentError, "dependencies must be a list of tuples"

  def resolve(_deps, []), do: []
  def resolve(_deps, [], _traversal_level), do: []

  def resolve(deps, [{key, value} = head | tail]) when is_tuple(head) do
    [{key, resolve(deps, value, 1)} | resolve(deps, tail)]
  end

  def resolve(deps, [{key, value} = head | tail], traversal_level) when is_tuple(head) do
    [{key, resolve(deps, value, traversal_level)} | resolve(deps, tail, traversal_level)]
  end

  def resolve(_deps, _list, traversal_level) when traversal_level >= @max_traversal_level do
    raise __MODULE__
  end

  def resolve(deps, [{mod, func, args} = h | rest] = list, traversal_level) when is_tuple(h) do
    IO.puts("zzz, #{inspect(list)}, #{traversal_level}")

    case List.keyfind(deps, {mod, func, length(args)}, 0) do
      {_action, deps_list} when length(deps_list) > 0 ->
        [
          {h, resolve(deps, deps_list, traversal_level + 1)}
          | resolve(deps, rest, traversal_level)
        ]
      _ -> [h | resolve(deps, rest, traversal_level)]
    end
  end
end
