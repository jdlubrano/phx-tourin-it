defmodule TourinIt.TourGoersFixtures do

  import TourinIt.AccountsFixtures
  import TourinIt.OrganizeFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `TourinIt.TourGoers` context.
  """

  @doc """
  Generate a tour_goer.
  """
  def tour_goer_fixture(user \\ user_fixture(), tour_session \\ tour_session_fixture()) do
    {:ok, tour_goer} = TourinIt.TourGoers.create_tour_goer(
      %{tour_session_id: tour_session.id, user_id: user.id}
    )

    tour_goer
  end
end
