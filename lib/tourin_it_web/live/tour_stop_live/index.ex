defmodule TourinItWeb.TourStopLive.Index do
  use TourinItWeb, :live_view

  import TourinItWeb.Access.TourGoer
  import TourinItWeb.TourStopComponents

  alias TourinIt.{Organize, Repo, TourStops}

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def mount(%{"tour_slug" => slug, "tour_session_identifier" => identifier}, _session, socket) do
    tour_session = Organize.get_tour_session!(%{identifier: identifier, slug: slug})
    ensure_invited!(socket.assigns.current_user, tour_session)

    tour_session = Repo.preload(tour_session, [:tour])
    tour_stops = TourStops.past_and_upcoming(tour_session.id)

    socket =
      socket
      |> assign(:page_title, "#{tour_session.tour.name} #{tour_session.identifier}")
      |> assign(:tour, tour_session.tour)
      |> assign(:tour_session, tour_session)
      |> assign(:tour_stops, tour_stops)

    {:ok, socket}
  end
end
