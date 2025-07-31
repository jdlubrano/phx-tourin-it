defmodule TourinIt.OrganizeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TourinIt.Organize` context.
  """

  @doc """
  Generate a tour.
  """
  def tour_fixture(attrs \\ %{}) do
    {:ok, tour} =
      attrs
      |> Enum.into(%{name: "some name"})
      |> TourinIt.Organize.create_tour()

    tour
  end

  @doc """
  Generate a tour_session.
  """
  def tour_session_fixture(tour \\ tour_fixture(), attrs \\ %{}) do
    {:ok, tour_session} =
      attrs
      |> Enum.into(%{
        identifier: "some identifier",
        tour_id: tour.id
      })
      |> TourinIt.Organize.create_tour_session()

    tour_session
  end
end
