defmodule TourinIt.TourGoers.TourGoer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tour_goers" do
    belongs_to :user, TourinIt.Accounts.User
    belongs_to :tour_session, TourinIt.Organize.TourSession

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tour_goer, attrs) do
    tour_goer
    |> cast(attrs, [:user_id, :tour_session_id])
    |> validate_required([:user_id, :tour_session_id])
    |> unique_constraint([:user_id, :tour_session_id])
  end
end
