defmodule TodoBackend.Router do
  use Commanded.Commands.Router

  alias TodoBackend.Todos.Aggregates.Todo
  alias TodoBackend.Todos.Commands.{CreateTodo, UpdateTodo, DeleteTodo}

  dispatch([CreateTodo, DeleteTodo, UpdateTodo], to: Todo, identity: :uuid)
end
