defmodule TourinItWeb.TourDateLive.FormComponent do
  use TourinItWeb, :live_component

  alias TourinIt.TourDates

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage tour_date records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tour_date-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" label="Date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tour date</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tour_date: tour_date} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(TourDates.change_tour_date(tour_date))
     end)}
  end

  @impl true
  def handle_event("validate", %{"tour_date" => tour_date_params}, socket) do
    changeset = TourDates.change_tour_date(socket.assigns.tour_date, tour_date_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"tour_date" => tour_date_params}, socket) do
    save_tour_date(socket, socket.assigns.action, tour_date_params)
  end

  defp save_tour_date(socket, :edit, tour_date_params) do
    case TourDates.update_tour_date(socket.assigns.tour_date, tour_date_params) do
      {:ok, tour_date} ->
        notify_parent({:saved, tour_date})

        {:noreply,
         socket
         |> put_flash(:info, "Tour date updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_tour_date(socket, :new, tour_date_params) do
    case TourDates.create_tour_date(tour_date_params) do
      {:ok, tour_date} ->
        notify_parent({:saved, tour_date})

        {:noreply,
         socket
         |> put_flash(:info, "Tour date created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
