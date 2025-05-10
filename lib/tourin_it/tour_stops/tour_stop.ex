defmodule TourinIt.TourStops.TourStop do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tour_stops" do
    field :destination, :string
    field :start_date, :date
    field :end_date, :date

    belongs_to :tour_session, TourinIt.Organize.TourSession

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tour_stop, attrs) do
    tour_stop
    |> cast(attrs, [:destination, :start_date, :end_date, :tour_session_id])
    |> validate_required([:destination, :start_date, :end_date, :tour_session_id])
  end
end
