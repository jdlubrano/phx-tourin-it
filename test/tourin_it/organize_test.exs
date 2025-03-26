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
end
