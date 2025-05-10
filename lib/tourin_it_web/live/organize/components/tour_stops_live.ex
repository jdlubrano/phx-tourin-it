defmodule TourinItWeb.Organize.Components.TourStopsLive do
  use TourinItWeb, :live_component

  def render(assigns) do
    ~H"""
    <section>
      <.header>Tour Stops</.header>
      <div>Tour stop count: {length(@tour_stops)}</div>
    </section>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, :tour_stops, assigns.tour_stops)}
  end
end
