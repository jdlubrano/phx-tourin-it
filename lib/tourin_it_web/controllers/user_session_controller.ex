defmodule TourinItWeb.UserSessionController do
  use TourinItWeb, :controller

  import TourinItWeb.UserAuth

  plug TourinItWeb.Plugs.UpcomingTourStop when action in [:new]

  def new(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/")
    else
      render(conn, :new)
    end
  end

  def destroy(conn, _params) do
    log_out_user(conn)
  end

end

