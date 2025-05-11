defmodule TourinItWeb.Organize.Components.TourStopsLive do
  use TourinItWeb, :live_component

  alias TourinIt.{Organize, Repo, TourStops}
  alias TourinIt.TourStops.TourStop

  def mount(socket) do
    socket =
      socket
      |> assign(:new_tour_stop, nil)
      |> assign(:editing_tour_stops, %{})

    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, :tour_session, assigns.tour_session)}
  end

  def handle_event("add_tour_stop", _params, socket) do
    socket = assign(socket, :new_tour_stop, %TourStop{})

    {:noreply, socket}
  end

  def handle_event("cancel", %{"id" => id}, socket) do
    editing_tour_stops = Map.put(socket.assigns.editing_tour_stops, id, false)

    {:noreply, assign(socket, :editing_tour_stops, editing_tour_stops)}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :new_tour_stop, nil)}
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
    {:ok, _tour_stop} = TourStops.create_tour_stop(create_params)

    {:noreply, reload_tour_session(socket)}
  end

  def handle_event("save", %{"tour_stop" => %{"id" => id} = tour_stop_params}, socket) do
    {:ok, %TourStop{}} = TourStops.update_tour_stop(%TourStop{id: String.to_integer(id)}, tour_stop_params)
    editing_tour_stops = Map.put(socket.assigns.editing_tour_stops, id, false)

    socket =
      reload_tour_session(socket)
      |> assign(:editing_tour_stops, editing_tour_stops)

    {:noreply, reload_tour_session(socket)}
  end

  attr :changeset, :any, required: true
  attr :myself, :any, required: true

  def tour_stop_form(assigns) do
    ~H"""
    <.form :let={f} for={@changeset} phx-submit="save" phx-target={@myself} class="contents">
      <.input field={f[:destination]} label="Destination" />
      <.input field={f[:start_date]} label="Start date" type="date" />
      <.input field={f[:end_date]} label="End date" type="date" />
      <span class="justify-self-center self-end">
        <.input field={f[:id]} type="hidden" />
        <.button type="submit">Save</.button>
        <button class="ml-2" type="button" phx-click="cancel" phx-target={@myself} phx-value-id={@changeset.data.id}>Cancel</button>
      </span>
    </.form>
    """
  end

  def render(assigns) do
    ~H"""
    <section>
      <p class="mb-6 leading-6 text-zinc-800">Tour stops</p>
      <div class="flex flex-col mb-4">
        <div class="grid grid-cols-4 gap-4 text-sm text-zinc-500 border-b border-zinc-200 pb-4 mb-4">
          <div>Destination</div>
          <div>Start date</div>
          <div>End date</div>
          <div><!-- Actions --></div>
        </div>
        <div :for={tour_stop <- @tour_session.tour_stops} class="grid grid-cols-4 gap-4 mb-4">
          <div :if={!@editing_tour_stops[Integer.to_string(tour_stop.id)]} class="contents">
            <div>{tour_stop.destination}</div>
            <div>{tour_stop.start_date}</div>
            <div>{tour_stop.end_date}</div>
            <div>
              <button type="button" phx-click="edit" phx-value-id={tour_stop.id} phx-target={@myself}>Edit</button>
              <button class="ml-2" type="button" phx-click="delete" phx-value-id={tour_stop.id} phx-target={@myself}>Delete</button>
            </div>
          </div>
          <.tour_stop_form :if={@editing_tour_stops[Integer.to_string(tour_stop.id)]} changeset={changeset(tour_stop)} myself={@myself} />
        </div>
      </div>

      <%= if is_nil(@new_tour_stop) do %>
        <button type="button" class="rounded-lg bg-green-200 py-2 px-2" phx-click="add_tour_stop" phx-target={@myself}>
          Add tour stop
        </button>
      <% else %>
        <div class="grid grid-cols-4 gap-4">
          <.tour_stop_form changeset={changeset(@new_tour_stop)} myself={@myself} />
        </div>
      <% end %>
    </section>
    """
  end

  defp changeset(%TourStop{} = tour_stop), do: TourStops.change_tour_stop(tour_stop)

  defp reload_tour_session(socket) do
    tour_session =
      Organize.get_tour_session!(socket.assigns.tour_session.id)
      |> Repo.preload(:tour_stops)

    assign(socket, :tour_session, tour_session)
  end
end
