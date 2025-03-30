defmodule TourinIt.Repo.Migrations.CreateTourSessions do
  use Ecto.Migration

  def change do
    create table(:tour_sessions) do
      add :identifier, :string, null: false
      add :tour_id, references(:tours, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tour_sessions, [:tour_id])
    create unique_index(:tour_sessions, [:identifier, :tour_id])
  end
end
