defmodule TourinItWeb.Organize.TourGoerController do
  use TourinItWeb, :controller

  alias TourinIt.Organize

  plug :load_tour_session

  def edit(conn, _params) do
    changeset = Organize.change_tour_goers(conn.assigns.tour_session)
    render(conn, :edit, changeset: changeset)
  end

  def update(conn, %{"tour_session" => tour_session_params}) do
    user_ids =
      Enum.map(tour_session_params["tour_goer_user_ids"], &String.to_integer(&1)) ||
        Enum.map(conn.assigns.tour_session.tour_goers, &(&1.user_id))

    case Organize.update_tour_goers(conn.assigns.tour_session, user_ids) do
      {:ok, tour_session} ->
        conn
        |> put_flash(:info, "Tour session updated successfully.")
        |> redirect(to: ~p"/organize/tours/#{tour_session.tour_id}/tour_sessions/#{tour_session}")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect changeset
        render(conn, :edit, changeset: changeset)
    end
  end

  defp load_tour_session(conn, _options) do
    %{"tour_id" => tour_id, "tour_session_id" => tour_session_id} = conn.path_params

    case Organize.get_tour_session(%{id: tour_session_id, tour_id: tour_id}) do
      nil ->
        conn
        |> put_flash(:error, "Could not find tour session ##{tour_session_id}")
        |> redirect(to: ~p"/organize/tours/#{tour_id}")
        |> halt()

      tour_session ->
        conn
        |> assign(:tour_session, TourinIt.Repo.preload(tour_session, [:tour, :tour_goers]))
    end
  end
end
