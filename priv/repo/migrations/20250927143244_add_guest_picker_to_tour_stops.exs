defmodule TourinIt.Repo.Migrations.AddGuestPickerToTourStops do
  use Ecto.Migration

  def change do
    alter table(:tour_stops) do
      add :guest_picker_id, references(:tour_goers, on_delete: :nilify_all), null: true
    end

    create index(:tour_stops, [:guest_picker_id])
  end
end
