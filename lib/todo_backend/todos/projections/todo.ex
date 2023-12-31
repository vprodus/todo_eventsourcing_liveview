defmodule TodoBackend.Todos.Projections.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}
  schema "todos" do
    field :title, :string
    field :completed, :boolean, default: false
    field :order, :integer, default: 0
    field :deleted_at, :naive_datetime_usec, default: nil

    timestamps()
  end

  @doc false
  def update_changeset(todo, attrs \\ %{}) do
    todo
    |> cast(attrs, [:title, :completed, :order])
  end

  def delete_changeset(todo, attrs \\ %{}) do
    todo
    |> cast(attrs, [:deleted_at])
  end
end
