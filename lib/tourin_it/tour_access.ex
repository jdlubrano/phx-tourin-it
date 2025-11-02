defmodule TourinIt.TourAccess do
  import Ecto.Query, warn: false

  alias TourinIt.Accounts.User
  alias TourinIt.Repo
  alias TourinIt.Organize.{Tour, TourSession}
  alias TourinIt.TourGoers.TourGoer

  def user_tour_sessions(%User{} = user, %Tour{} = tour) do
    query =
      from ts in TourSession,
        where: ts.tour_id == ^tour.id,
        order_by: [desc: ts.identifier]

    query =
      if TourinIt.Accounts.admin?(user) do
        query
      else
        from ts in query,
          join: tg in TourGoer,
          on: tg.tour_session_id == ts.id,
          where: tg.user_id == ^user.id
      end

    Repo.all(query)
  end
end
