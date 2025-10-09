defmodule TourinItWeb.TourStopComponents do
  use TourinItWeb, :html

  alias TourinIt.TourStops
  alias TourinIt.TourStops.TourStop

  attr :current_user, TourinIt.Accounts.User, required: true
  attr :tour_stop, TourStop, required: true

  def destination(assigns) do
    ~H"""
    {@tour_stop.destination}<.guest_picker_badge current_user={@current_user} tour_stop={@tour_stop} />
    """
  end

  attr :current_user, TourinIt.Accounts.User, required: true
  attr :tour_stop, TourStop, required: true

  defp guest_picker_badge(%{current_user: current_user, tour_stop: tour_stop} = assigns) do
    cond do
      is_nil(tour_stop.guest_picker) ->
        ~H"""
        """

      TourStops.guest_picker?(tour_stop, current_user) ->
        ~H"""
        <span class="ml-1 p-1 rounded-lg bg-yellow-200">Your pick!</span>
        """

      true ->
        ~H"""
        <span class="ml-1 p-1 rounded-lg bg-neutral-200 capitalize">
          {@tour_stop.guest_picker.user.username}'s pick!
        </span>
        """
    end
  end

  attr :current_user, TourinIt.Accounts.User, required: true
  attr :tour_stop, TourStop, required: true

  def tour_stop_details(assigns) do
    ~H"""
    <p class="font-semibold mb-8 text-zinc-700">
      {format_date(@tour_stop.start_date)} - {format_date(@tour_stop.end_date)}
    </p>
    <p class="font-semibold mb-8 text-zinc-700">
      <.tour_stop_occasion occasion={@tour_stop.occasion} /> @
      <.destination current_user={@current_user} tour_stop={@tour_stop} />
    </p>
    """
  end

  attr :occasion, :atom, required: true, values: Ecto.Enum.values(TourStop, :occasion)

  def tour_stop_occasion(assigns) do
    ~H"""
    <span class="capitalize">
      {raw(occasion_emoji(@occasion))}
      {@occasion}
    </span>
    """
  end

  defp occasion_emoji(occasion) do
    case occasion do
      :breakfast ->
        Enum.random([
          "&#127849;",
          "&#129363;",
          "&#129374;",
          "&#129479;"
        ])

      :dinner ->
        Enum.random([
          "&#127790;",
          "&#127828;",
          "&#127831;",
          "&#127837;",
          "&#127843;",
          "&#129385;"
        ])
    end
  end
end
