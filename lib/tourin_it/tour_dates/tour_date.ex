defmodule TourinIt.TourDates.TourDate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tour_dates" do
    field :date, :date

    belongs_to :tour_stop, TourinIt.TourStops.TourStop

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tour_date, attrs) do
    tour_date
    |> cast(attrs, [:date, :tour_stop_id])
    |> validate_required([:date, :tour_stop_id])
    |> unique_constraint([:date, :tour_stop_id])
  end
end
