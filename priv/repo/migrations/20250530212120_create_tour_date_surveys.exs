defmodule TourinIt.Repo.Migrations.CreateTourDateSurveys do
  use Ecto.Migration

  def change do
    create table(:tour_date_surveys) do
      add :availability, :string, null: false
      add :note, :string

      add :tour_date_id, references(:tour_dates, on_delete: :delete_all), null: false
      add :tour_goer_id, references(:tour_goers, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tour_date_surveys, [:tour_date_id])
    create unique_index(:tour_date_surveys, [:tour_goer_id, :tour_date_id])
  end
end
