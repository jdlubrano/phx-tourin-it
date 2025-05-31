defmodule TourinItWeb.TourStopSurveyLive.Edit do
  use TourinItWeb, :live_view

  alias TourinIt.{Repo, TourDates, TourGoers, TourStops}

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def mount(%{"id" => id}, _session, socket) do
    tour_stop = TourStops.get_tour_stop!(id)
    ensure_invited!(socket.assigns.current_user, tour_stop.tour_session_id)

    tour_stop = Repo.preload(tour_stop, [:tour_dates, tour_session: :tour])

    tour_goer = TourGoers.get_tour_goer!(socket.assigns.current_user.id, tour_stop.tour_session_id)
    surveys = TourDates.load_or_build_surveys(tour_goer, tour_stop.tour_dates)

    socket =
      socket
      |> assign(:surveys, surveys)
      |> assign(:tour_stop, tour_stop)

    {:ok, socket}
  end

  defp ensure_invited!(current_user, tour_session_id) do
    unless TourGoers.invited?(current_user.id, tour_session_id) || Accounts.admin?(current_user) do
      raise TourinItWeb.UserNotInvitedError, "User ##{current_user.id} not invited to TourSession ##{tour_session_id}"
    end
  end
end
