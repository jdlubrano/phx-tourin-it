defmodule TourinItWeb.GuestPickLive.Edit do
  use TourinItWeb, :live_view

  import TourinItWeb.TourStopComponents

  alias TourinIt.{Repo, TourStops}

  def mount(%{"tour_stop_id" => tour_stop_id}, _session, socket) do
    tour_stop =
      TourStops.get_tour_stop!(tour_stop_id)
      |> Repo.preload(guest_picker: :user, tour_session: :tour)

    if TourStops.guest_picker?(tour_stop, socket.assigns.current_user) do
      socket =
        socket
        |> assign(:tour_stop, tour_stop)
        |> assign(:changeset, TourStops.change_tour_stop(tour_stop))
        |> assign(
          :page_title,
          "#{tour_stop.tour_session.tour.name} #{tour_stop.tour_session.identifier} Guest Pick"
        )

      {:ok, socket}
    else
      {:ok, push_navigate(socket, to: ~p"/")}
    end
  end

  def handle_event("save", %{"tour_stop" => %{"destination" => destination}}, socket) do
    socket =
      case TourStops.update_guest_pick(socket.assigns.tour_stop, %{destination: destination}) do
        {:error, changeset} ->
          assign(socket, :changeset, changeset)

        {:ok, tour_stop} ->
          socket
          |> assign(:changeset, TourStops.change_tour_stop(tour_stop))
          |> assign(:tour_stop, tour_stop)
          |> put_flash(:info, "Guest pick saved!")
      end

    {:noreply, socket}
  end
end
