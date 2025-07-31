defmodule TourinItWeb.PageController do
  use TourinItWeb, :controller

  alias TourinIt.Organize
  alias TourinIt.Organize.TourSession

  plug :redirect_to_upcoming_tour_date

  def home(conn, _params) do
    render(conn, :home)
  end

  defp redirect_to_upcoming_tour_date(conn, _options) do
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
