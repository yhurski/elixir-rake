defmodule ElixirRake do
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :elixir_rake_tasks_with_deps, [])
      Module.put_attribute(__MODULE__, :elixir_rake_tasks_with_deps, [])

      @on_definition ElixirRake
      @before_compile ElixirRake
    end
  end

  def __on_definition__(env, _kind, name, args, _guards, _body) do
    import ElixirRake.Dependency.Formatter

    description = Module.delete_attribute(env.module, :elixir_rake_desc)
    dependencies = Module.delete_attribute(env.module, :elixir_rake_task_deps)
    global_deps = Module.get_attribute(env.module, :elixir_rake_tasks_with_deps)
    mod = env.module

    if description do
      if dependencies do
        Module.put_attribute(
          env.module,
          :elixir_rake_tasks_with_deps,
          [{{mod, name, length(args)}, description, expand_each(dependencies, mod)} | global_deps]
        )
      else
        Module.put_attribute(
          env.module,
          :elixir_rake_tasks_with_deps,
          {name, description, [{{mod, name, args}, description, []} | global_deps]}
        )
      end
    end
  end

  defmacro __before_compile__(env) do
    import ElixirRake.Dependency.Resolver

    tasks_with_deps = Module.get_attribute(env.module, :elixir_rake_tasks_with_deps)
    IO.inspect [">>>", tasks_with_deps]

    quote do
      def __elixir_rake_tasks_deps__(), do: unquote(Macro.escape(resolve(tasks_with_deps)))
    end
  end

  defmacro desc(text) do
    quote do
      Module.put_attribute(__MODULE__, :elixir_rake_desc, unquote(text))
    end
  end

  defmacro depends_on(args) do
    quote do
      Module.register_attribute(__MODULE__, :elixir_rake_task_deps, accumulate: true)
      Module.put_attribute(__MODULE__, :elixir_rake_task_deps, unquote(args))
    end
  end
end
