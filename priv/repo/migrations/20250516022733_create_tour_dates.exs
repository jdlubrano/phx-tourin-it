defmodule TourinIt.Repo.Migrations.CreateTourDates do
  use Ecto.Migration

  def change do
    create table(:tour_dates) do
      add :date, :date, null: false
      add :tour_stop_id, references(:tour_stops, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tour_dates, [:tour_stop_id])
    create unique_index(:tour_dates, [:date, :tour_stop_id])
  end
end
