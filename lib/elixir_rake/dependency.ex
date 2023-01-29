defmodule ElixirRake.Dependency do
  @max_traversal_level 128

  defexception message: """
    Max dependency depth level was exceeded (max level allowed is #{@max_traversal_level}). \
    Probably, you've got a circular dependency.
    """

  def flatten([]), do: []
  def flatten(deps) do
    cond do
      Keyword.keyword?(deps) -> flatten(deps, deps)
      true -> raise ArgumentError, "dependencies must be a keyword"
    end
  end

  def flatten(_deps, []), do: []
  def flatten(_deps, [], _traversal_level), do: []

  def flatten(deps, [{key, value} = head | tail] = rest) when is_tuple(head) do
    [{key, flatten(deps, value, 1)} | flatten(deps, tail)]
  end

  def flatten(_deps, _list, traversal_level) when traversal_level >= @max_traversal_level do
    raise __MODULE__
  end

  def flatten(deps, [h|rest] = list, traversal_level) when is_atom(h) do
    IO.puts "zzz, #{inspect list}, #{traversal_level}"
    if Keyword.has_key?(deps, h) do
      [{h, flatten(deps, Keyword.get(deps, h), traversal_level + 1)} | flatten(deps, rest, traversal_level)]
    else
      [h | flatten(deps, rest, traversal_level)]
    end
  end

end


