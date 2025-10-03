defmodule TourinItWeb.Organize.TourSessionLive do
  use TourinItWeb, :live_view

  import TourinItWeb.OrganizeComponents

  alias TourinIt.{Accounts, Organize, Repo}
  alias TourinItWeb.Organize.TourStopsComponent

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def render(assigns) do
    ~H"""
    <.back navigate={~p"/organize/tours/#{@tour_session.tour}"}>
      Back to {@tour_session.tour.name}
    </.back>
    <.header class="mb-8">Tour Session {@tour_session.identifier}</.header>

    <div class="mb-8">
      <.link
        class="underline"
        target="_blank"
        navigate={~p"/tours/#{@tour_session.tour.slug}/#{@tour_session.identifier}"}
      >
        View as tour goer
      </.link>
    </div>

    <.live_component module={TourStopsComponent} id="tour_stops" tour_session={@tour_session} />

    <hr class="mt-8 mb-16" />

    <section>
      <.tour_goers_table
        tour_session={@tour_session}
        tour_goers={@tour_session.tour_goers}
        user_access_tokens={@user_access_tokens}
      />
      <div class="mt-2">
        <.text_link navigate={
          ~p"/organize/tours/#{@tour_session.tour}/tour_sessions/#{@tour_session}/tour_goers/edit"
        }>
          Edit tour goers
        </.text_link>
      </div>
    </section>
    """
  end

  def mount(%{"tour_id" => tour_id, "id" => id}, _session, socket) do
    tour_session =
      Organize.get_tour_session!(%{id: id, tour_id: tour_id})
      |> Repo.preload([:tour, tour_stops: [guest_picker: :user], tour_goers: :user])

    user_access_tokens =
      tour_session.tour_goers
      |> Enum.map(& &1.user_id)
      |> Accounts.newest_tokens_for_users()

    {
      :ok,
      socket
      |> assign(:tour_session, tour_session)
      |> assign(:user_access_tokens, user_access_tokens)
    }
  end

  def handle_event("generate_access_token", %{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)
    encoded_token = Accounts.generate_user_access_token(user)

    updated =
      update(socket, :user_access_tokens, fn user_access_tokens ->
        Map.put(user_access_tokens, user.id, %{encoded_token: encoded_token})
      end)

    {:noreply, updated}
  end
end
