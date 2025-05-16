defmodule TourinItWeb.TourStopLive.Show do
  use TourinItWeb, :live_view

  alias TourinIt.Repo
  alias TourinIt.{Accounts, Organize, TourDates, TourGoers ,TourStops}
  alias TourinIt.TourDates.TourDate
  alias TourinIt.TourStops.TourStop

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def mount(%{"tour_slug" => slug, "tour_session_identifier" => identifier}, _session, socket) do
    tour_session = Organize.get_tour_session!(%{identifier: identifier, slug: slug}) |> Repo.preload(:tour)
    ensure_invited!(socket.assigns.current_user, tour_session)

    tour_stop = TourStops.upcoming(tour_session.id)

    socket =
      socket
      |> assign(:tour_session, tour_session)
      |> assign(:tour_stop, tour_stop)

    {:ok, socket}
  end

  defp ensure_invited!(current_user, tour_session) do
    unless TourGoers.invited?(current_user.id, tour_session.id) || Accounts.admin?(current_user) do
      raise TourinItWeb.UserNotInvitedError, "User ##{current_user.id} not invited to TourSession ##{tour_session.id}"
    end
  end
end
