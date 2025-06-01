defmodule TourinItWeb.TourDateLive.Show do
  use TourinItWeb, :live_view

  alias TourinIt.TourDates

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tour_date, TourDates.get_tour_date!(id))}
  end

  defp page_title(:show), do: "Show Tour date"
  defp page_title(:edit), do: "Edit Tour date"
end
