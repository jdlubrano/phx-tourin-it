defmodule TourinIt.TourGoersTest do
  use TourinIt.DataCase

  alias TourinIt.TourGoers

  describe "tour_goers" do
    alias TourinIt.TourGoers.TourGoer

    import TourinIt.AccountsFixtures
    import TourinIt.OrganizeFixtures
    import TourinIt.TourGoersFixtures

    test "create_tour_goer/1 creates a tour_goer" do
      tour_session = tour_session_fixture(tour_fixture())
      user = user_fixture()

      {:ok, tour_goer = %TourGoer{}} = TourGoers.create_tour_goer(%{tour_session_id: tour_session.id, user_id: user.id})

      assert tour_goer.tour_session_id == tour_session.id
      assert tour_goer.user_id == user.id
    end

    test "create_tour_goer/1 fails for invalid attrs" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = TourGoers.create_tour_goer(%{user_id: user.id})
    end

    test "get_tour_goer!/1 returns the tour_goer with given id" do
      tour_goer = tour_goer_fixture()
      assert TourGoers.get_tour_goer!(tour_goer.id) == tour_goer
    end

    test "delete_tour_goer/1 deletes the tour_goer" do
      tour_goer = tour_goer_fixture()
      assert {:ok, %TourGoer{}} = TourGoers.delete_tour_goer(tour_goer)
      assert_raise Ecto.NoResultsError, fn -> TourGoers.get_tour_goer!(tour_goer.id) end
    end
  end
end
