defmodule TourinItWeb.TourDateLive.Index do
  use TourinItWeb, :live_view

  alias TourinIt.TourDates
  alias TourinIt.TourDates.TourDate

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tour_dates, TourDates.list_tour_dates())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tour date")
    |> assign(:tour_date, TourDates.get_tour_date!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tour date")
    |> assign(:tour_date, %TourDate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tour dates")
    |> assign(:tour_date, nil)
  end

  @impl true
  def handle_info({TourinItWeb.TourDateLive.FormComponent, {:saved, tour_date}}, socket) do
    {:noreply, stream_insert(socket, :tour_dates, tour_date)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tour_date = TourDates.get_tour_date!(id)
    {:ok, _} = TourDates.delete_tour_date(tour_date)

    {:noreply, stream_delete(socket, :tour_dates, tour_date)}
  end
end
