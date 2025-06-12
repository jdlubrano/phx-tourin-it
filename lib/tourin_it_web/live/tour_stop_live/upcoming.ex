defmodule TourinItWeb.TourStopLive.Upcoming do
  use TourinItWeb, :live_view

  import TourinItWeb.Access.TourGoer

  alias TourinIt.{Organize, Repo, TourStops}
  alias TourinIt.TourStops.TourStop

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def mount(%{"tour_slug" => slug, "tour_session_identifier" => identifier}, _session, socket) do
    tour_session = Organize.get_tour_session!(%{identifier: identifier, slug: slug})
    ensure_invited!(socket.assigns.current_user, tour_session)

    case TourStops.upcoming(tour_session.id) do
      %TourStop{} = tour_stop ->
        socket = push_navigate(socket, to: ~p"/tour_stops/#{tour_stop}")
        {:ok, socket}

      _ ->
        tour = Repo.preload(tour_session, :tour).tour

        socket =
          socket
          |> assign(:page_title, "#{tour.name} #{tour_session.identifier}")
          |> assign(:tour, tour)
          |> assign(:tour_session, tour_session)

        {:ok, socket}
    end
  end
end
