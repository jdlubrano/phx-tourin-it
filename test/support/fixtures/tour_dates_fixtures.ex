defmodule TourinIt.TourDatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TourinIt.TourDates` context.
  """

  alias TourinIt.TourDates

  @doc """
  Generate a tour_date.
  """
  def tour_date_fixture(attrs \\ %{}) do
    {:ok, tour_date} =
      attrs
      |> Enum.into(%{
        date: ~D[2025-05-15]
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
