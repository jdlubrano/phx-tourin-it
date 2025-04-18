defmodule TourinItWeb.MeController do
  use TourinItWeb, :controller

  def show(conn, _params) do
    render(conn, :show, user: conn.assigns[:current_user])
  end
end
