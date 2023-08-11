defmodule TodoBackend.Router do
  use Commanded.Commands.Router

  alias TodoBackend.Todos.Aggregates.Todo
  alias TodoBackend.Todos.Commands.{CreateTodo, UpdateTodo, DeleteTodo, RestoreTodo}

  dispatch([CreateTodo, DeleteTodo, UpdateTodo, RestoreTodo], to: Todo, identity: :uuid)
end
