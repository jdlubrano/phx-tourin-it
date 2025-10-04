defmodule TourinIt.Repo.Migrations.AllowNullTourStopsDestination do
  use Ecto.Migration

  # SQLite does not support altering columns.  The workaround is:
  # 1. Rename the existing column
  # 2. Add new nullable column
  # 3. Backfill the new column from the renamed column
  # 4. Drop the renamed column
  def up do
    execute "ALTER TABLE tour_stops ADD COLUMN destination_temp"
    execute "UPDATE tour_stops SET destination_temp = destination"
    execute "ALTER TABLE tour_stops DROP COLUMN destination"
    execute "ALTER TABLE tour_stops ADD COLUMN destination TEXT NULL"
    execute "UPDATE tour_stops SET destination = destination_temp"
    execute "ALTER TABLE tour_stops DROP COLUMN destination_temp"
  end

  def down, do: nil
end
