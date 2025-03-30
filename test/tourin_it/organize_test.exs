defmodule TourinIt.OrganizeTest do
  use TourinIt.DataCase

  alias TourinIt.Organize

  describe "tours" do
    alias TourinIt.Organize.Tour

    import TourinIt.OrganizeFixtures

    @invalid_attrs %{name: nil}

    test "list_tours/0 returns all tours" do
      tour = tour_fixture()
      assert Organize.list_tours() == [tour]
    end

    test "get_tour!/1 returns the tour with given id" do
      tour = tour_fixture()
      assert Organize.get_tour!(tour.id) == tour
    end

    test "create_tour/1 with valid data creates a tour" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tour{} = tour} = Organize.create_tour(valid_attrs)
      assert tour.name == "some name"
      assert tour.slug == "some-name"
    end

    test "create_tour/1 stores slugs downcased" do
      valid_attrs = %{name: "Some Name"}

      assert {:ok, %Tour{} = tour} = Organize.create_tour(valid_attrs)
      assert tour.name == "Some Name"
      assert tour.slug == "some-name"
    end

    test "create_tour/1 generates a unique slug" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tour{} = tour} = Organize.create_tour(valid_attrs)
      assert tour.slug == "some-name"

      assert {:ok, %Tour{} = tour} = Organize.create_tour(valid_attrs)
      assert tour.slug == "some-name-1"

      assert {:ok, %Tour{} = tour} = Organize.create_tour(valid_attrs)
      assert tour.slug == "some-name-2"
    end

    test "create_tour/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organize.create_tour(@invalid_attrs)
    end

    test "update_tour/2 with valid data updates the tour" do
      tour = tour_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tour{} = tour} = Organize.update_tour(tour, update_attrs)
      assert tour.name == "some updated name"
    end

    test "update_tour/2 with valid data does not update the slug" do
      {:ok, tour} =
        tour_fixture()
        |> change(%{slug: "saved-slug"})
        |> Repo.update()

      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, tour} = Organize.update_tour(tour, update_attrs)

      assert tour.name == "some updated name"
      assert tour.slug == "saved-slug"
    end

    test "update_tour/2 with invalid data returns error changeset" do
      tour = tour_fixture()
      assert {:error, %Ecto.Changeset{}} = Organize.update_tour(tour, @invalid_attrs)
      assert tour == Organize.get_tour!(tour.id)
    end

    test "delete_tour/1 deletes the tour" do
      tour = tour_fixture()
      assert {:ok, %Tour{}} = Organize.delete_tour(tour)
      assert_raise Ecto.NoResultsError, fn -> Organize.get_tour!(tour.id) end
    end

    test "change_tour/1 returns a tour changeset" do
      tour = tour_fixture()
      assert %Ecto.Changeset{} = Organize.change_tour(tour)
    end
  end

  describe "tour_sessions" do
    alias TourinIt.Organize.TourSession

    import TourinIt.OrganizeFixtures

    @invalid_attrs %{identifier: nil}

    setup do
      {:ok, tour: tour_fixture()}
    end

    test "list_tour_sessions/0 returns all tour_sessions", %{tour: tour} do
      tour_session = tour_session_fixture(tour)
      other_tour = tour_fixture()
      assert Organize.list_tour_sessions(tour) == [tour_session]
      assert Organize.list_tour_sessions(other_tour) == []
    end

    test "get_tour_session!/1 returns the tour_session with given id", %{tour: tour} do
      tour_session = tour_session_fixture(tour)
      assert Organize.get_tour_session!(tour_session.id) == tour_session
    end

    test "create_tour_session/1 with valid data creates a tour_session", %{tour: tour} do
      valid_attrs = %{identifier: "some identifier", tour_id: tour.id}

      assert {:ok, %TourSession{} = tour_session} = Organize.create_tour_session(valid_attrs)
      assert tour_session.identifier == "some identifier"
    end

    test "create_tour_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organize.create_tour_session(@invalid_attrs)
    end

    test "update_tour_session/2 with valid data updates the tour_session", %{tour: tour} do
      tour_session = tour_session_fixture(tour)
      update_attrs = %{identifier: "some updated identifier"}

      assert {:ok, %TourSession{} = tour_session} = Organize.update_tour_session(tour_session, update_attrs)
      assert tour_session.identifier == "some updated identifier"
    end

    test "update_tour_session/2 with invalid data returns error changeset", %{tour: tour} do
      tour_session = tour_session_fixture(tour)
      assert {:error, %Ecto.Changeset{}} = Organize.update_tour_session(tour_session, @invalid_attrs)
      assert tour_session == Organize.get_tour_session!(tour_session.id)
    end

    test "delete_tour_session/1 deletes the tour_session", %{tour: tour} do
      tour_session = tour_session_fixture(tour)
      assert {:ok, %TourSession{}} = Organize.delete_tour_session(tour_session)
      assert_raise Ecto.NoResultsError, fn -> Organize.get_tour_session!(tour_session.id) end
    end

    test "change_tour_session/1 returns a tour_session changeset" do
      tour_session = %TourSession{}
      assert %Ecto.Changeset{} = Organize.change_tour_session(tour_session)
    end
  end
end
