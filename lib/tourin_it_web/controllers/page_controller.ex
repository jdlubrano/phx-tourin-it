defmodule TourinItWeb.PageController do
  use TourinItWeb, :controller

  plug TourinItWeb.Plugs.UpcomingTourStop

  def home(conn, _params) do
    if conn.assigns.current_user do
      render(conn, :home)
    else
      redirect(conn, to: ~p"/log_in")
    end
  end
end
