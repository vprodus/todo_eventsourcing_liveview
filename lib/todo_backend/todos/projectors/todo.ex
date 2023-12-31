defmodule TodoBackend.Todos.Projectors.Todo do
  use Commanded.Projections.Ecto,
    name: "Todos.Projectors.Todo",
    application: TodoBackend.App,
    consistency: :strong

  alias TodoBackend.Repo

  alias TodoBackend.Todos.Events.{TodoCreated, TodoDeleted, TodoCompleted, TodoUncompleted, TodoTitleUpdated, TodoOrderUpdated,TodoRestored}

  alias TodoBackend.Todos.Projections.Todo

  project(%TodoCreated{} = created, _, fn multi ->
    Ecto.Multi.insert(multi, :todo, %Todo{
      uuid: created.uuid,
      title: created.title,
      completed: created.completed,
      order: created.order
    })
  end)

  project(%TodoDeleted{uuid: uuid, datetime: effective_datetime}, _, fn multi ->
    # Ecto.Multi.delete(multi, :todo, fn _ -> %Todo{uuid: uuid} end)
    case Repo.get(Todo, uuid) do
      nil ->
        multi

      todo ->
        Ecto.Multi.update(
          multi,
          :todo,
          Todo.delete_changeset(todo, %{deleted_at: effective_datetime})
        )
    end
  end)

  project(%TodoCompleted{uuid: uuid}, _, fn multi ->
    case Repo.get(Todo, uuid) do
      nil -> multi
      todo -> Ecto.Multi.update(multi, :todo, Todo.update_changeset(todo, %{completed: true}))
    end
  end)

  project(%TodoUncompleted{uuid: uuid}, _, fn multi ->
    case Repo.get(Todo, uuid) do
      nil -> multi
      todo -> Ecto.Multi.update(multi, :todo, Todo.update_changeset(todo, %{completed: false}))
    end
  end)

  project(%TodoTitleUpdated{uuid: uuid, title: title}, _, fn multi ->
    case Repo.get(Todo, uuid) do
      nil -> multi
      todo -> Ecto.Multi.update(multi, :todo, Todo.update_changeset(todo, %{title: title}))
    end
  end)

  project(%TodoOrderUpdated{uuid: uuid, order: order}, _, fn multi ->
    case Repo.get(Todo, uuid) do
      nil -> multi
      todo -> Ecto.Multi.update(multi, :todo, Todo.update_changeset(todo, %{order: order}))
    end
  end)

  project(%TodoRestored{uuid: uuid}, _, fn multi ->
    case Repo.get(Todo, uuid) do
      nil ->
        multi

      todo ->
        Ecto.Multi.update(multi, :todo, Todo.delete_changeset(todo, %{deleted_at: nil}))
    end
  end)
end
