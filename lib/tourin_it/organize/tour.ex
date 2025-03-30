defmodule TourinIt.Organize.Tour do
  use Ecto.Schema
  import Ecto.Changeset
  alias TourinIt.Organize.TourSession

  schema "tours" do
    has_many :tour_sessions, TourSession

    field :name, :string
    field :slug, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tour, attrs) do
    tour
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end
end
