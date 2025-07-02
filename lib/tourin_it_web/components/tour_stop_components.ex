defmodule TourinItWeb.TourStopComponents do
  use TourinItWeb, :html

  alias TourinIt.TourStops.TourStop

  attr :occasion, :atom, required: true, values: Ecto.Enum.values(TourStop, :occasion)
  def tour_stop_occasion(assigns) do
    ~H"""
    <span class="capitalize">
      {raw(occasion_emoji(assigns.occasion))}
      {assigns.occasion}
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
