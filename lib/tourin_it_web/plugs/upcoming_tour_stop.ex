defmodule TourinItWeb.Plugs.UpcomingTourStop do
  use TourinItWeb, :controller

  import Plug.Conn

  alias TourinIt.Organize
  alias TourinIt.Organize.TourSession

  def init(default), do: default

  def call(conn, _default) do
    case Organize.default_tour_session(conn.assigns.current_user) do
      %TourSession{} = tour_session ->
        conn
        |> redirect(to: ~p"/tours/#{tour_session.tour.slug}/#{tour_session.identifier}/upcoming")
        |> halt()

      _ ->
        conn
    end
  end
end
