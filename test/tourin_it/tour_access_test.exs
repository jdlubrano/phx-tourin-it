defmodule TourinIt.TourAccessTest do
  use TourinIt.DataCase

  import TourinIt.AccountsFixtures
  import TourinIt.OrganizeFixtures
  import TourinIt.TourGoersFixtures

  alias TourinIt.TourAccess

  describe "tour session access" do
    setup do
      tour = tour_fixture()
      tour_session = tour_session_fixture(tour)

      {:ok, tour: tour, tour_session: tour_session}
    end

    test "user_tour_sessions/2 returns tour sessions the user is invited to", %{
      tour: tour,
      tour_session: tour_session
    } do
      user = user_fixture()
      tour_sessions = TourAccess.user_tour_sessions(user, tour)
      assert tour_sessions == []

      tour_goer_fixture(user, tour_session)
      tour_sessions = TourAccess.user_tour_sessions(user, tour)
      assert tour_sessions == [tour_session]
    end

    test "user_tour_sessions/2 excludes other tours' tour sessions", %{tour_session: tour_session} do
      user = user_fixture()
      tour_goer_fixture(user, tour_session)
      other_tour = tour_fixture()
      tour_sessions = TourAccess.user_tour_sessions(user, other_tour)

      assert tour_sessions == []
    end

    test "user_tour_sessions/2 excludes other users' tour sessions", %{
      tour: tour,
      tour_session: tour_session
    } do
      user = user_fixture()
      tour_goer_fixture(user, tour_session)

      other_tour_session = tour_session_fixture(tour, %{identifier: "other tour session"})
      other_user = user_fixture()
      tour_goer_fixture(other_user, other_tour_session)
      tour_sessions = TourAccess.user_tour_sessions(user, tour)

      assert tour_sessions == [tour_session]
    end

    test "user_tour_sessions/2 returns all tour sessions for admin users", %{
      tour: tour,
      tour_session: tour_session
    } do
      admin = admin_user_fixture()
      tour_sessions = TourAccess.user_tour_sessions(admin, tour)

      assert tour_sessions == [tour_session]
    end
  end
end
