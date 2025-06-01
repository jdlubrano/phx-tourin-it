defmodule TourinIt.TourDatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TourinIt.TourDates` context.
  """

  @doc """
  Generate a tour_date.
  """
  def tour_date_fixture(attrs \\ %{}) do
    {:ok, tour_date} =
      attrs
      |> Enum.into(%{
        date: ~D[2025-05-15]
      })
      |> TourinIt.TourDates.create_tour_date()

    tour_date
  end
end
