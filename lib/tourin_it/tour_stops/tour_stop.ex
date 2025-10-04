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
    |> cast(attrs, [
      :destination,
      :guest_picker_id,
      :occasion,
      :start_date,
      :end_date,
      :tour_session_id
    ])
    |> validate_required([:occasion, :start_date, :end_date, :tour_session_id])
    |> validate_destination_or_guest_picker()
  end

  @doc false
  def update_changeset(tour_stop, attrs) do
    tour_stop
    |> cast(attrs, [:destination, :guest_picker_id, :occasion, :start_date, :end_date])
    |> validate_required([:occasion, :start_date, :end_date])
    |> validate_destination_or_guest_picker()
  end

  @doc false
  def guest_pick_changeset(tour_stop, attrs) do
    tour_stop
    |> cast(attrs, [:destination])
    |> validate_required([:destination])
  end

  @doc false
  defp validate_destination_or_guest_picker(changeset) do
    destination = get_field(changeset, :destination)
    guest_picker_id = get_field(changeset, :guest_picker_id)

    case destination || guest_picker_id do
      nil ->
        add_error(changeset, :destination, "required")

      _ ->
        changeset
    end
  end
end
