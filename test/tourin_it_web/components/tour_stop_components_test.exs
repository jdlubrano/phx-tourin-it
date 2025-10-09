defmodule TourinItWeb.TourStopComponentsTest do
  use TourinIt.DataCase

  import Phoenix.LiveViewTest
  import TourinIt.AccountsFixtures
  import TourinIt.TourGoersFixtures
  import TourinIt.TourStopsFixtures
  import TourinItWeb.TourStopComponents

  alias TourinIt.Accounts.User
  alias TourinIt.TourStops
  alias TourinIt.TourStops.TourStop

  setup do
    %{
      assigns: %{},
      tour_stop: TourinIt.Repo.preload(tour_stop_fixture(), :guest_picker),
      user: user_fixture()
    }
  end

  defp set_guest_picker(%TourStop{} = tour_stop, %User{} = user) do
    tour_goer = tour_goer_fixture(user)
    {:ok, tour_stop} = TourStops.update_tour_stop(tour_stop, %{guest_picker_id: tour_goer.id})

    TourStops.get_tour_stop!(tour_stop.id)
    |> Repo.preload(guest_picker: :user)
  end

  test "destination component with no guest picker", %{tour_stop: tour_stop, user: user} do
    assert render_component(&destination/1, current_user: user, tour_stop: tour_stop) ==
             tour_stop.destination
  end

  test "destination component with guest picker", %{tour_stop: tour_stop, user: user} do
    other_user = user_fixture()
    tour_stop = set_guest_picker(tour_stop, other_user)

    content = render_component(&destination/1, current_user: user, tour_stop: tour_stop)

    assert content =~ tour_stop.destination
    assert content =~ "#{other_user.username}'s pick!"
  end

  test "destination component with current user guest picker", %{tour_stop: tour_stop, user: user} do
    tour_stop = set_guest_picker(tour_stop, user)

    content = render_component(&destination/1, current_user: user, tour_stop: tour_stop)

    assert content =~ tour_stop.destination
    assert content =~ "Your pick!"
  end
end
