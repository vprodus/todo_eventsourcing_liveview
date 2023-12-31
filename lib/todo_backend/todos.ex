defmodule TodoBackend.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoBackend.Repo
  alias TodoBackend.App
  alias TodoBackend.Todos.Commands.{CreateTodo, DeleteTodo, UpdateTodo, RestoreTodo}
  alias TodoBackend.Todos.Projections.Todo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    # Repo.all(Todo)
    from(t in Todo,
      where: is_nil(t.deleted_at)
    )
    |> Repo.all()
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!("51004ff5-5a73-4681-87bb-1b1ffbf03fe0")
      %Todo{}

      iex> get_todo!("00000000-0000-0000-0000-000000000000")
      ** (Ecto.NoResultsError)

  """
  # def get_todo!(uuid), do: Repo.get!(Todo, uuid: uuid)
  def get_todo!(uuid) do
    from(t in Todo,
      where: is_nil(t.deleted_at)
    )
    |> Repo.get_by!(uuid: uuid)
  end

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    # %Todo{}
    # |> Todo.changeset(attrs)
    # |> Repo.insert()
    uuid = Ecto.UUID.generate()

    command =
      attrs
      |> CreateTodo.new()
      |> CreateTodo.assign_uuid(uuid)

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, get_todo!(uuid)}
    else
      reply -> reply
    end
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{uuid: uuid}, attrs) do
    # todo
    # |> Todo.changeset(attrs)
    # |> Repo.update()
    command =
      attrs
      |> UpdateTodo.new()
      |> UpdateTodo.assign_uuid(uuid)

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, get_todo!(uuid)}
    else
      reply -> reply
    end
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{uuid: uuid}) do
    # Repo.delete(todo)
    command = DeleteTodo.new(%{uuid: uuid})

    with :ok <- App.dispatch(command) do
      :ok
    else
      reply -> reply
    end
  end

  def restore_todo(id) do
    command = %RestoreTodo{uuid: id}

    with :ok <- App.dispatch(command, consistency: :strong) do
      {:ok, get_todo!(id)}
    else
      reply -> reply
    end
  end

  @doc """
  Deletes all todos.

  ## Examples

      iex> delete_all_todos()
      {deleted_count, nil}

  """
  def delete_all_todos() do
    # Repo.delete_all(Todo)
    stream = Repo.stream(Todo)
    correlation_id = Ecto.UUID.generate()

    Repo.transaction(fn ->
      Enum.each(stream, fn todo ->
        App.dispatch(
          DeleteTodo.new(%{uuid: todo.uuid}),
          correlation_id: correlation_id
        )
      end)
    end)
  end
end
