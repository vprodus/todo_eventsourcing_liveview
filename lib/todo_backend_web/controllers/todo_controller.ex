defmodule TodoBackendWeb.TodoController do
  use TodoBackendWeb, :controller

  alias TodoBackend.Todos
  alias TodoBackend.Todos.Projections.Todo

  action_fallback TodoBackendWeb.FallbackController

  def index(conn, _params) do
    todos = Todos.list_todos()
    render(conn, :index, todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    with {:ok, %Todo{} = todo} <- Todos.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todos/#{todo}")
      |> render(:show, todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    render(conn, :show, todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id)

    with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, :show, todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)

    with :ok <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete_all(conn, _params) do
    Todos.delete_all_todos()

    send_resp(conn, :no_content, "")
  end
end
