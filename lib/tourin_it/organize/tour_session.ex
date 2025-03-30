defmodule TourinIt.Organize.TourSession do
  use Ecto.Schema
  import Ecto.Changeset
  alias TourinIt.Organize.Tour

  schema "tour_sessions" do
    belongs_to :tour, Tour
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
end
