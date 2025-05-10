defmodule TourinIt.Repo.Migrations.CreateTourStops do
  use Ecto.Migration

  def change do
    create table(:tour_stops) do
      add :destination, :string, null: false
      add :start_date, :date, null: false
      add :end_date, :date, null: false
      add :tour_session_id, references(:tour_sessions, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tour_stops, [:tour_session_id])
  end
end
