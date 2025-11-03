defmodule TourinIt.TourAccess do
  import Ecto.Query, warn: false

  alias TourinIt.Accounts.User
  alias TourinIt.Repo
  alias TourinIt.Organize.{Tour, TourSession}
  alias TourinIt.TourGoers.TourGoer

  def user_tours(%User{} = user) do
    query =
      from t in Tour,
        join: ts in TourSession,
        on: ts.tour_id == t.id,
        join: tg in TourGoer,
        on: tg.tour_session_id == ts.id,
        where: tg.user_id == ^user.id,
        order_by: [asc: t.name]

    Repo.all(query)
  end

  def user_tour_sessions(%User{} = user, %Tour{} = tour) do
    query =
      from ts in TourSession,
        where: ts.tour_id == ^tour.id,
        join: tg in TourGoer,
        on: tg.tour_session_id == ts.id,
        where: tg.user_id == ^user.id,
        order_by: [desc: ts.identifier]

    Repo.all(query)
  end
end
