defmodule TourinIt.Repo.Migrations.CreateTourGoers do
  use Ecto.Migration

  def change do
    create table(:tour_goers) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :tour_session_id, references(:tour_sessions, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tour_goers, [:user_id])
    create unique_index(:tour_goers, [:tour_session_id, :user_id])
  end
end
