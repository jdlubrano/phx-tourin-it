defmodule TourinIt.Organize.TourSession do
  use Ecto.Schema
  import Ecto.Changeset
  alias TourinIt.Organize.Tour
  alias TourinIt.Repo
  alias TourinIt.TourGoers.TourGoer

  schema "tour_sessions" do
    belongs_to :tour, Tour

    has_many :tour_goers, TourGoer, preload_order: [asc: :id], on_replace: :delete_if_exists

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
    |> cast_assoc(:tour_goers, with: &TourGoer.changeset/2)
  end
end
