defmodule TourinItWeb.Organize.TourSessionController do
  use TourinItWeb, :controller

  alias TourinIt.Organize
  alias TourinIt.Organize.TourSession

  plug :load_tour when action in [:new, :create]
  plug :load_tour_session when action in [:edit, :update, :delete]

  def new(conn, _params) do
    changeset = Organize.change_tour_session(%TourSession{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"tour_session" => tour_session_params}) do
    tour_session_params = Map.put(tour_session_params, "tour_id", conn.assigns[:tour].id)

    case Organize.create_tour_session(tour_session_params) do
      {:ok, _tour_session} ->
        conn
        |> put_flash(:info, "Tour Session created successfully.")
        |> redirect(to: ~p"/organize/tours/#{conn.assigns[:tour]}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, _params) do
    changeset = Organize.change_tour_session(conn.assigns.tour_session)
    render(conn, :edit, changeset: changeset)
  end

  def update(conn, %{"tour_session" => tour_session_params}) do
    case Organize.update_tour_session(conn.assigns.tour_session, tour_session_params) do
      {:ok, tour_session} ->
        conn
        |> put_flash(:info, "Tour session updated successfully.")
        |> redirect(to: ~p"/organize/tours/#{tour_session.tour}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    {:ok, tour_session} = Organize.delete_tour_session(conn.assigns.tour_session)

    conn
    |> put_flash(:info, "Tour session deleted successfully.")
    |> redirect(to: ~p"/organize/tours/#{tour_session.tour_id}")
  end

  defp load_tour(conn, _options) do
    %{"tour_id" => tour_id} = conn.path_params

    case Organize.get_tour(tour_id) do
      nil ->
        conn
        |> redirect(to: ~p"/organize/tours")
        |> halt()

      tour ->
        Plug.Conn.assign(conn, :tour, tour)
    end
  end

  defp load_tour_session(conn, _options) do
    %{"id" => id, "tour_id" => tour_id} = conn.path_params
    tour_session = Organize.get_tour_session!(%{id: id, tour_id: tour_id})

    Plug.Conn.assign(conn, :tour_session, tour_session)
  end
end
