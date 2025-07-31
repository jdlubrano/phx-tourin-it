defmodule TourinItWeb.Organize.TourSessionControllerTest do
  use TourinItWeb.ConnCase

  import TourinIt.OrganizeFixtures
  alias TourinIt.Organize

  @create_attrs %{identifier: "some identifier"}
  @update_attrs %{identifier: "some updated identifier"}
  @invalid_attrs %{identifier: nil}

  setup do
    {:ok, tour: tour_fixture()}
  end

  setup :create_and_log_in_admin

  describe "new tour_session" do
    test "renders form", %{conn: conn, tour: tour} do
      conn = get(conn, ~p"/organize/tours/#{tour}/tour_sessions/new")
      assert html_response(conn, 200) =~ "New Tour Session"
    end

    test "redirects to tours index when an invalid tour_id is provided", %{conn: conn} do
      conn = get(conn, ~p"/organize/tours/0/tour_sessions/new")
      assert redirected_to(conn) == ~p"/organize/tours"
    end
  end

  describe "create tour" do
    test "redirects to tour when data is valid", %{conn: conn, tour: tour} do
      conn = post(conn, ~p"/organize/tours/#{tour}/tour_sessions", tour_session: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/organize/tours/#{id}"

      tour_sessions = Organize.list_tour_sessions(tour)
      assert Enum.count(tour_sessions) == 1
    end

    test "renders errors when data is invalid", %{conn: conn, tour: tour} do
      conn = post(conn, ~p"/organize/tours/#{tour}/tour_sessions", tour_session: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tour Session"
    end
  end

  describe "edit tour session" do
    setup [:create_tour_session]

    test "renders form for editing chosen tour", %{
      conn: conn,
      tour: tour,
      tour_session: tour_session
    } do
      conn = get(conn, ~p"/organize/tours/#{tour}/tour_sessions/#{tour_session}/edit")
      assert html_response(conn, 200) =~ "Edit Tour Session"
    end
  end

  describe "update tour session" do
    setup [:create_tour_session]

    test "redirects when data is valid", %{conn: conn, tour: tour, tour_session: tour_session} do
      conn =
        put(conn, ~p"/organize/tours/#{tour}/tour_sessions/#{tour_session}",
          tour_session: @update_attrs
        )

      assert redirected_to(conn) == ~p"/organize/tours/#{tour}"

      updated_session = Organize.get_tour_session!(tour_session.id)
      assert updated_session.identifier == "some updated identifier"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      tour: tour,
      tour_session: tour_session
    } do
      conn =
        put(conn, ~p"/organize/tours/#{tour}/tour_sessions/#{tour_session}",
          tour_session: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "cannot be blank"
      assert html_response(conn, 200) =~ "Edit Tour Session"
    end
  end

  defp create_tour_session(%{tour: tour}) do
    %{tour_session: tour_session_fixture(tour)}
  end
end
