defmodule TodoBackendWeb.TodoJSON do
  alias TodoBackend.Todos.Todo

  @doc """
  Renders a list of todos.
  """
  def index(%{todos: todos}) do
    %{data: for(todo <- todos, do: data(todo))}
  end

  @doc """
  Renders a single todo.
  """
  def show(%{todo: todo}) do
    %{data: data(todo)}
  end

  defp data(%Todo{} = todo) do
    %{
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
      order: todo.order,
      url: Routes.todo_url(Endpoint, :show, todo.id)
    }
  end
end
