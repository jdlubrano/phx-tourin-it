defmodule TourinItWeb.TourLive.Index do
  use TourinItWeb, :live_view

  alias TourinIt.TourAccess

  def mount(_params, _session, socket) do
    tours = TourAccess.user_tours(socket.assigns.current_user)
    {:ok, assign(socket, :tours, tours)}
  end
end
