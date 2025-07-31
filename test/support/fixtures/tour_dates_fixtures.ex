defmodule TourinIt.TourDatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TourinIt.TourDates` context.
  """

  import TourinIt.TourStopsFixtures

  alias TourinIt.TourDates

  @doc """
  Generate a tour_date.
  """
  def tour_date_fixture(tour_stop \\ tour_stop_fixture(), attrs \\ %{}) do
    {:ok, tour_date} =
      attrs
      |> Enum.into(%{
        date: ~D[2025-05-15],
        tour_stop_id: tour_stop.id
      })
      |> TourDates.create_tour_date()

    tour_date
  end

  def tour_date_survey_fixture(attrs \\ %{}) do
    {:ok, survey} =
      attrs
      |> Enum.into(%{
        availability: :tbd
      })
      |> TourDates.create_tour_date_survey()

    survey
  end
end
