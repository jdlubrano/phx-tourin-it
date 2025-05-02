defmodule TourinItWeb.Organize.TourSessionLive do
  use TourinItWeb, :live_view

  import TourinItWeb.OrganizeComponents

  alias TourinIt.{Organize, Repo}

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def render(assigns) do
    ~H"""
    <.back navigate={~p"/organize/tours/#{@tour_session.tour}"}>Back to {@tour_session.tour.name}</.back>
    <.header class="mb-8">Tour Session {@tour_session.identifier}</.header>

    <section>
      <.tour_goers_table tour_goers={@tour_session.tour_goers} />
      <div class="mt-2">
        <.text_link navigate={~p"/organize/tours/#{@tour_session.tour}/tour_sessions/#{@tour_session}/tour_goers/edit"}>
          Edit tour goers
        </.text_link>
      </div>
    </section>
    """
  end

  def mount(%{"tour_id" => tour_id, "id" => id}, _session, socket) do
    tour_session = Organize.get_tour_session!(%{id: id, tour_id: tour_id})
                   |> Repo.preload([:tour, tour_goers: :user])

    {:ok, assign(socket, :tour_session, tour_session)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
