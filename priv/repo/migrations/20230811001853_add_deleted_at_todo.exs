defmodule TodoBackend.Repo.Migrations.AddDeletedAtTodo do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add :deleted_at, :naive_datetime_usec
    end

    create index(:todos, [:deleted_at])
  end
end
