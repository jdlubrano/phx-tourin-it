defmodule TourinIt.TourDates.TourDateSurvey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tour_date_surveys" do
    field :availability, Ecto.Enum, values: [:tbd, :available, :unavailable]

    belongs_to :tour_date, TourinIt.TourDates.TourDate
    belongs_to :tour_goer, TourinIt.TourGoers.TourGoer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tour_date_survey, attrs) do
    tour_date_survey
    |> cast(attrs, [:availability])
    |> validate_required([:availability])
  end
end
