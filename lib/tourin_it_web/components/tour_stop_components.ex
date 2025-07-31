defmodule TourinItWeb.TourStopComponents do
  use TourinItWeb, :html

  alias TourinIt.TourStops.TourStop

  attr :tour_stop, TourStop, required: true

  def tour_stop_details(assigns) do
    ~H"""
    <p class="font-semibold mb-8 text-zinc-700">
      {format_date(@tour_stop.start_date)} - {format_date(@tour_stop.end_date)}
    </p>
    <p class="font-semibold mb-8 text-zinc-700">
      <.tour_stop_occasion occasion={@tour_stop.occasion} /> @ {@tour_stop.destination}
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
