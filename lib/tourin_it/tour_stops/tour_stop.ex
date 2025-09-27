defmodule TourinIt.TourStops.TourStop do
  use Ecto.Schema
  import Ecto.Changeset

  alias TourinIt.TourDates.TourDate

  schema "tour_stops" do
    field :destination, :string
    field :occasion, Ecto.Enum, default: :dinner, values: [:breakfast, :dinner]
    field :start_date, :date
    field :end_date, :date

    belongs_to :guest_picker, TourinIt.TourGoers.TourGoer
    belongs_to :tour_session, TourinIt.Organize.TourSession

    has_many :tour_dates, TourDate, preload_order: [asc: :date]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tour_stop, attrs) do
    tour_stop
    |> cast(attrs, [:destination, :occasion, :start_date, :end_date, :tour_session_id])
    |> validate_required([:destination, :occasion, :start_date, :end_date, :tour_session_id])
  end

  @doc false
  def update_changeset(tour_stop, attrs) do
    tour_stop
    |> cast(attrs, [:destination, :occasion, :start_date, :end_date])
    |> validate_required([:destination, :occasion, :start_date, :end_date])
  end
end
