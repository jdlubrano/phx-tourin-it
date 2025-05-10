defmodule TourinIt.TourStopsFixtures do

  import TourinIt.OrganizeFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `TourinIt.TourStops` context.
  """

  @doc """
  Generate a tour_stop.
  """
  def tour_stop_fixture(tour_session \\ tour_session_fixture(), attrs \\ %{}) do
    {:ok, tour_stop} =
      attrs
      |> Enum.into(%{
        destination: "some destination",
        end_date: ~D[2025-05-09],
        start_date: ~D[2025-05-09],
        tour_session_id: tour_session.id
      })
      |> TourinIt.TourStops.create_tour_stop()

    tour_stop
  end
end
