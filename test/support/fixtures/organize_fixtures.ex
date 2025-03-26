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
end
