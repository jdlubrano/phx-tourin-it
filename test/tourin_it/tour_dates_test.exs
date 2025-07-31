defmodule TourinIt.TourDatesTest do
  use TourinIt.DataCase

  alias TourinIt.TourDates

  describe "tour_dates" do
    alias TourinIt.Repo
    alias TourinIt.TourDates.{TourDate, TourDateSurvey}

    import TourinIt.TourDatesFixtures
    import TourinIt.TourGoersFixtures
    import TourinIt.TourStopsFixtures

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
      valid_attrs = %{date: ~D[2025-05-15], tour_stop_id: tour_stop_fixture().id}

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

    test "upsert_surveys/1 inserts new surveys" do
      tour_goer = tour_goer_fixture() |> Repo.preload(:tour_session)
      tour_stop = tour_stop_fixture(tour_goer.tour_session)
      tour_date = tour_date_fixture(tour_stop)

      {count, _} = TourDates.upsert_surveys([%{
        availability: :tbd,
        note:         "test note",
        tour_goer_id: tour_goer.id,
        tour_date_id: tour_date.id
      }])

      assert count == 1
    end

    test "upsert_surveys/1 updates existing surveys" do
      tour_goer = tour_goer_fixture() |> Repo.preload(:tour_session)
      tour_stop = tour_stop_fixture(tour_goer.tour_session)
      tour_date = tour_date_fixture(tour_stop)

      tour_date_survey = tour_date_survey_fixture(%{tour_goer_id: tour_goer.id, tour_date_id: tour_date.id})

      new_survey_attrs = %{
        availability: :tbd,
        tour_date_id: tour_date_fixture(tour_stop, %{date: Date.add(tour_date.date, 1)}).id,
        tour_goer_id: tour_goer.id
      }

      existing_survey_attrs = %{
        availability: :available,
        tour_date_id: tour_date.id,
        tour_goer_id: tour_goer.id
      }

      upserts = [existing_survey_attrs, new_survey_attrs]

      {count, _} = TourDates.upsert_surveys(upserts)
      assert count == length(upserts)

      updated_survey = Repo.get!(TourDateSurvey, tour_date_survey.id)
      assert updated_survey.availability == :available
    end
  end
end
