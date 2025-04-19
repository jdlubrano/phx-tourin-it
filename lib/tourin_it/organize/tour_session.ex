defmodule TourinIt.Organize.TourSession do
  use Ecto.Schema
  import Ecto.Changeset
  alias TourinIt.Organize.Tour
  alias TourinIt.Repo

  schema "tour_sessions" do
    belongs_to :tour, Tour

    has_many :tour_goers, TourinIt.TourGoers.TourGoer, preload_order: [asc: :id]

    field :identifier, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tour_session, attrs) do
    tour_session
    |> cast(attrs, [:identifier, :tour_id])
    |> validate_required([:identifier, :tour_id])
    |> foreign_key_constraint(:tour_id)
    |> unique_constraint([:identifier, :tour_id])
  end

  @doc false
  def tour_goers_changeset(tour_session, attrs \\ %{}) do
    tour_session
    |> Repo.preload(:tour_goers)
    |> cast(attrs, [])
    |> cast_assoc(:tour_goers, with: &TourinIt.TourGoers.TourGoer.changeset/2)
  end
end
