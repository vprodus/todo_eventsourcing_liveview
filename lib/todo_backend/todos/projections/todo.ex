defmodule TodoBackend.Todos.Projections.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @derive {Phoenix.Param, key: :uuid}
  schema "todos" do
    field :title, :string
    field :completed, :boolean, default: false
    field :order, :integer, default: 0

    timestamps()
  end

  @doc false
  def update_changeset(todo, attrs \\ %{}) do
    todo
    |> cast(attrs, [:title, :completed, :order])
  end
end
