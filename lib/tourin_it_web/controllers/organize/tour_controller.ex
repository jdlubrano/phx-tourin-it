defmodule TourinItWeb.Organize.TourController do
  use TourinItWeb, :controller

  alias TourinIt.Organize
  alias TourinIt.Organize.Tour

  def index(conn, _params) do
    tours = Organize.list_tours()
    render(conn, :index, tours: tours)
  end

  def new(conn, _params) do
    changeset = Organize.change_tour(%Tour{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"tour" => tour_params}) do
    case Organize.create_tour(tour_params) do
      {:ok, tour} ->
        conn
        |> put_flash(:info, "Tour created successfully.")
        |> redirect(to: ~p"/organize/tours/#{tour}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tour = Organize.get_tour!(id)
    tour_sessions = Organize.list_tour_sessions(tour)
    render(conn, :show, tour: tour, tour_sessions: tour_sessions)
  end

  def edit(conn, %{"id" => id}) do
    tour = Organize.get_tour!(id)
    changeset = Organize.change_tour(tour)
    render(conn, :edit, tour: tour, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tour" => tour_params}) do
    tour = Organize.get_tour!(id)

    case Organize.update_tour(tour, tour_params) do
      {:ok, tour} ->
        conn
        |> put_flash(:info, "Tour updated successfully.")
        |> redirect(to: ~p"/organize/tours/#{tour}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, tour: tour, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tour = Organize.get_tour!(id)
    {:ok, _tour} = Organize.delete_tour(tour)

    conn
    |> put_flash(:info, "Tour deleted successfully.")
    |> redirect(to: ~p"/organize/tours")
  end
end
