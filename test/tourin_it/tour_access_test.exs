defmodule TourinIt.TourAccessTest do
  use TourinIt.DataCase

  import TourinIt.AccountsFixtures
  import TourinIt.OrganizeFixtures
  import TourinIt.TourGoersFixtures

  alias TourinIt.TourAccess

  setup do
    tour = tour_fixture()
    tour_session = tour_session_fixture(tour)

    {:ok, tour: tour, tour_session: tour_session, user: user_fixture()}
  end

  describe "user_tours/1" do
    test "returns tours that the user is invited to", %{
      tour: tour,
      tour_session: tour_session,
      user: user
    } do
      tours = TourAccess.user_tours(user)
      assert tours == []

      tour_goer_fixture(user, tour_session)
      tours = TourAccess.user_tours(user)
      assert tours == [tour]
    end

    test "excludes other users' tours", %{
      tour: tour,
      tour_session: tour_session,
      user: user
    } do
      tour_goer_fixture(user, tour_session)

      other_user = user_fixture()
      new_tour = tour_fixture()
      new_session = tour_session_fixture(new_tour, %{identifier: "new session"})
      tour_goer_fixture(other_user, new_session)

      tours = TourAccess.user_tours(user)
      assert tours == [tour]
    end
  end

  describe "user_tour_sessions/2" do
    test "returns tour sessions the user is invited to", %{
      tour: tour,
      tour_session: tour_session,
      user: user
    } do
      tour_sessions = TourAccess.user_tour_sessions(user, tour)
      assert tour_sessions == []

      tour_goer_fixture(user, tour_session)
      tour_sessions = TourAccess.user_tour_sessions(user, tour)
      assert tour_sessions == [tour_session]
    end

    test "excludes other tours' tour sessions", %{
      tour_session: tour_session,
      user: user
    } do
      tour_goer_fixture(user, tour_session)
      other_tour = tour_fixture()
      tour_sessions = TourAccess.user_tour_sessions(user, other_tour)

      assert tour_sessions == []
    end

    test "excludes other users' tour sessions", %{
      tour: tour,
      tour_session: tour_session,
      user: user
    } do
      tour_goer_fixture(user, tour_session)

      other_tour_session = tour_session_fixture(tour, %{identifier: "other tour session"})
      other_user = user_fixture()
      tour_goer_fixture(other_user, other_tour_session)
      tour_sessions = TourAccess.user_tour_sessions(user, tour)

      assert tour_sessions == [tour_session]
    end
  end
end
