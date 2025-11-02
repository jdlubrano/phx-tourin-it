defmodule TourinItWeb.TourSessionLive.Index do
  use TourinItWeb, :live_view

  alias TourinIt.Organize
  alias TourinIt.Organize.Tour
  alias TourinIt.TourAccess

  def mount(%{"tour_slug" => slug}, _session, socket) do
    %{tour: tour, tour_sessions: tour_sessions} =
      load_tour_sessions(socket.assigns.current_user, slug)

    socket =
      case tour_sessions do
        [] ->
          socket
          |> put_flash(:error, "Could not find #{slug}")
          |> redirect(to: ~p"/")

        tour_sessions ->
          socket
          |> assign(:tour, tour)
          |> assign(:tour_sessions, tour_sessions)
      end

    {:ok, socket}
  end

  defp load_tour_sessions(user, slug) do
    case Organize.get_tour_by_slug(slug) do
      %Tour{} = tour ->
        %{tour: tour, tour_sessions: TourAccess.user_tour_sessions(user, tour)}

      nil ->
        %{tour: nil, tour_sessions: nil}
    end
  end
end
