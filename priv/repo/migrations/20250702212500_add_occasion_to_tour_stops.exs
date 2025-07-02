defmodule TourinIt.Repo.Migrations.AddOccasionToTourStops do
  use Ecto.Migration

  def change do
    alter table("tour_stops") do
      add :occasion, :string, null: false, default: "dinner"
    end
  end
end
