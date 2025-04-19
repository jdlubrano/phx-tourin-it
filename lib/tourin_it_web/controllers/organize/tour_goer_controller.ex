defmodule TourinItWeb.Organize.TourGoerController do
  use TourinItWeb, :controller

  alias TourinIt.Organize

  plug :load_tour_session

  def edit(conn, _params) do
    changeset = Organize.change_tour_goers(conn.assigns.tour_session)
    # tour_goers = Organize.list_tour_goers(conn.assigns.tour_session)

    render(conn, :edit, changeset: changeset)
  end

  defp load_tour_session(conn, _options) do
    %{"tour_id" => tour_id, "tour_session_id" => tour_session_id} = conn.path_params

    case Organize.get_tour_session(%{id: tour_session_id, tour_id: tour_id}) do
      nil ->
        conn
        |> put_flash(:error, "Could not find tour session ##{tour_session_id}")
        |> redirect(to: ~p"/organize/tours/#{tour_id}")
        |> halt()

      tour_session -> Plug.Conn.assign(conn, :tour_session, TourinIt.Repo.preload(tour_session, [:tour, :tour_goers]))
    end
  end
end
