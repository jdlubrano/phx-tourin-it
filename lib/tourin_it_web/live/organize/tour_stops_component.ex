defmodule TourinItWeb.Organize.TourStopsComponent do
  use TourinItWeb, :live_component

  alias TourinIt.{Organize, Repo, TourStops}
  alias TourinIt.TourStops.TourStop

  def mount(socket) do
    socket =
      socket
      |> assign(:new_tour_stop_changeset, nil)
      |> assign(:editing_tour_stops, %{})

    {:ok, socket}
  end

def update(assigns, socket) do
  socket =
    assign(socket, :tour_session, assigns.tour_session)
    |> reload_tour_session()

  {:ok, socket}
end

  def handle_event("add_tour_stop", _params, socket) do
    socket = assign(socket, :new_tour_stop_changeset, TourStops.change_tour_stop(%TourStop{}))

    {:noreply, socket}
  end

  def handle_event("cancel", %{"id" => id}, socket) do
    editing_tour_stops = Map.put(socket.assigns.editing_tour_stops, id, false)

    {:noreply, assign(socket, :editing_tour_stops, editing_tour_stops)}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :new_tour_stop_changeset, nil)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    int_id = String.to_integer(id)
    Repo.delete(%TourStop{id: int_id})

    {:noreply, reload_tour_session(socket)}
  end

  def handle_event("edit", %{"id" => id}, socket) do
    editing_tour_stops = Map.put(socket.assigns.editing_tour_stops, id, true)

    {:noreply, assign(socket, :editing_tour_stops, editing_tour_stops)}
  end

  def handle_event("save", %{"tour_stop" => %{"id" => ""} = tour_stop_params}, socket) do
    create_params = Map.put(tour_stop_params, "tour_session_id", socket.assigns.tour_session.id)

    socket =
      case TourStops.create_tour_stop_with_dates(create_params) do
        {:ok, _tour_stop} ->
          socket
          |> assign(:new_tour_stop_changeset, nil)
          |> reload_tour_session()

        {:error, changeset = %Ecto.Changeset{}} ->
          socket
          |> assign(:new_tour_stop_changeset, changeset)
      end

    {:noreply, socket}
  end

  def handle_event("save", %{"tour_stop" => %{"id" => id} = tour_stop_params}, socket) do
    Repo.transaction(fn ->
      {:ok, %TourStop{} = tour_stop} =
        TourStops.update_tour_stop(TourStops.get_tour_stop!(id), tour_stop_params)

      TourStops.set_tour_dates(tour_stop)
    end)

    editing_tour_stops = Map.put(socket.assigns.editing_tour_stops, id, false)

    socket =
      reload_tour_session(socket)
      |> assign(:editing_tour_stops, editing_tour_stops)

    {:noreply, socket}
  end

  def occasion_options() do
    Ecto.Enum.values(TourStop, :occasion)
  end

  def guest_picker_options(tour_session) do
    tour_goers = Repo.preload(tour_session, tour_goers: :user).tour_goers

    Enum.map(tour_goers, fn tour_goer ->
      [key: tour_goer.user.username, value: tour_goer.id]
    end)
  end

  defp changeset(%TourStop{} = tour_stop), do: TourStops.change_tour_stop(tour_stop)

  defp reload_tour_session(socket) do
    tour_session =
      Organize.get_tour_session!(socket.assigns.tour_session.id)
      |> Repo.preload(tour_stops: [guest_picker: :user])

    assign(socket, :tour_session, tour_session)
  end

  embed_templates "*"

  attr :changeset, :any, required: true
  attr :target, :any, required: true

  def tour_stop_form(assigns)
end
