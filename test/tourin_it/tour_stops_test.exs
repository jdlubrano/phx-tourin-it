defmodule TourinIt.TourStopsTest do
  use TourinIt.DataCase

  alias TourinIt.{Repo, TourStops}

  describe "tour_stops" do
    alias TourinIt.TourStops.TourStop

    import TourinIt.OrganizeFixtures
    import TourinIt.TourStopsFixtures

    @invalid_attrs %{destination: nil, start_date: nil, end_date: nil}

    test "list_tour_stops/0 returns all tour_stops" do
      tour_stop = tour_stop_fixture()
      assert TourStops.list_tour_stops() == [tour_stop]
    end

    test "get_tour_stop!/1 returns the tour_stop with given id" do
      tour_stop = tour_stop_fixture()
      assert TourStops.get_tour_stop!(tour_stop.id) == tour_stop
    end

    test "create_tour_stop/1 with valid data creates a tour_stop" do
      tour_session = tour_session_fixture()

      valid_attrs = %{
        destination:     "some destination",
        start_date:      ~D[2025-05-09],
        end_date:        ~D[2025-05-09],
        tour_session_id: tour_session.id
      }

      assert {:ok, %TourStop{} = tour_stop} = TourStops.create_tour_stop(valid_attrs)
      assert tour_stop.destination == "some destination"
      assert tour_stop.start_date == ~D[2025-05-09]
      assert tour_stop.end_date == ~D[2025-05-09]

      tour_stop = Repo.preload(tour_stop, :tour_session)
      assert tour_stop.tour_session == tour_session
    end

    test "create_tour_stop/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TourStops.create_tour_stop(@invalid_attrs)
    end

    test "create_tour_stop_with_dates/1 with valid data creates a tour_stop with tour_dates" do
      tour_session = tour_session_fixture()

      valid_attrs = %{
        destination:     "some destination",
        start_date:      ~D[2025-05-09],
        end_date:        ~D[2025-05-10],
        tour_session_id: tour_session.id
      }

      assert {:ok, %TourStop{} = tour_stop} = TourStops.create_tour_stop_with_dates(valid_attrs)

      tour_dates = Repo.preload(tour_stop, :tour_dates).tour_dates
      assert length(tour_dates) == 2
      assert Enum.map(tour_dates, &(&1.date)) == [~D[2025-05-09], ~D[2025-05-10]]
    end

    test "create_tour_stop_with_dates/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TourStops.create_tour_stop_with_dates(@invalid_attrs)
    end

    test "set_tour_dates/1 ensures a TourDate for each day in the TourStop's date range" do
      tour_session = tour_session_fixture()

      valid_attrs = %{
        destination:     "some destination",
        start_date:      ~D[2025-05-09],
        end_date:        ~D[2025-05-12],
        tour_session_id: tour_session.id
      }

      {:ok, tour_stop} = TourStops.create_tour_stop_with_dates(valid_attrs)
      tour_dates = Repo.preload(tour_stop, :tour_dates).tour_dates
      expected_dates = Enum.to_list(Date.range(valid_attrs[:start_date], valid_attrs[:end_date]))
      assert Enum.map(tour_dates, &(&1.date)) == expected_dates

      retained_tour_dates = Enum.slice(tour_dates, 1..2)
      {:ok, tour_stop} = TourStops.update_tour_stop(tour_stop, %{start_date: ~D[2025-05-10], end_date: ~D[2025-05-11]})
      tour_stop = TourStops.set_tour_dates(tour_stop) |> Repo.preload(:tour_dates)

      assert length(tour_stop.tour_dates) == 2
      assert tour_stop.tour_dates == retained_tour_dates
    end

    test "update_tour_stop/2 with valid data updates the tour_stop" do
      tour_stop = tour_stop_fixture()
      update_attrs = %{destination: "some updated destination", start_date: ~D[2025-05-10], end_date: ~D[2025-05-10]}

      assert {:ok, %TourStop{}} = TourStops.update_tour_stop(%TourStop{id: tour_stop.id}, update_attrs)

      tour_stop = TourStops.get_tour_stop!(tour_stop.id)
      assert tour_stop.destination == "some updated destination"
      assert tour_stop.start_date == ~D[2025-05-10]
      assert tour_stop.end_date == ~D[2025-05-10]
    end

    test "update_tour_stop/2 with invalid data returns error changeset" do
      tour_stop = tour_stop_fixture()
      assert {:error, %Ecto.Changeset{}} = TourStops.update_tour_stop(tour_stop, @invalid_attrs)
      assert tour_stop == TourStops.get_tour_stop!(tour_stop.id)
    end

    test "delete_tour_stop/1 deletes the tour_stop" do
      tour_stop = tour_stop_fixture()
      assert {:ok, %TourStop{}} = TourStops.delete_tour_stop(tour_stop)
      assert_raise Ecto.NoResultsError, fn -> TourStops.get_tour_stop!(tour_stop.id) end
    end

    test "change_tour_stop/1 returns a tour_stop changeset" do
      tour_stop = tour_stop_fixture()
      assert %Ecto.Changeset{} = TourStops.change_tour_stop(tour_stop)
    end
  end
end
