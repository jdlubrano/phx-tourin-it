defmodule TourinIt.TourDatesTest do
  use TourinIt.DataCase

  alias TourinIt.TourDates

  describe "tour_dates" do
    alias TourinIt.TourDates.TourDate

    import TourinIt.TourDatesFixtures

    @invalid_attrs %{date: nil}

    test "list_tour_dates/0 returns all tour_dates" do
      tour_date = tour_date_fixture()
      assert TourDates.list_tour_dates() == [tour_date]
    end

    test "get_tour_date!/1 returns the tour_date with given id" do
      tour_date = tour_date_fixture()
      assert TourDates.get_tour_date!(tour_date.id) == tour_date
    end

    test "create_tour_date/1 with valid data creates a tour_date" do
      valid_attrs = %{date: ~D[2025-05-15]}

      assert {:ok, %TourDate{} = tour_date} = TourDates.create_tour_date(valid_attrs)
      assert tour_date.date == ~D[2025-05-15]
    end

    test "create_tour_date/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TourDates.create_tour_date(@invalid_attrs)
    end

    test "update_tour_date/2 with valid data updates the tour_date" do
      tour_date = tour_date_fixture()
      update_attrs = %{date: ~D[2025-05-16]}

      assert {:ok, %TourDate{} = tour_date} = TourDates.update_tour_date(tour_date, update_attrs)
      assert tour_date.date == ~D[2025-05-16]
    end

    test "update_tour_date/2 with invalid data returns error changeset" do
      tour_date = tour_date_fixture()
      assert {:error, %Ecto.Changeset{}} = TourDates.update_tour_date(tour_date, @invalid_attrs)
      assert tour_date == TourDates.get_tour_date!(tour_date.id)
    end

    test "delete_tour_date/1 deletes the tour_date" do
      tour_date = tour_date_fixture()
      assert {:ok, %TourDate{}} = TourDates.delete_tour_date(tour_date)
      assert_raise Ecto.NoResultsError, fn -> TourDates.get_tour_date!(tour_date.id) end
    end

    test "change_tour_date/1 returns a tour_date changeset" do
      tour_date = tour_date_fixture()
      assert %Ecto.Changeset{} = TourDates.change_tour_date(tour_date)
    end
  end
end
