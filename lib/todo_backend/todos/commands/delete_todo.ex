defmodule TodoBackend.Todos.Commands.DeleteTodo do
  defstruct [
    :uuid
  ]

  use ExConstructor
end
