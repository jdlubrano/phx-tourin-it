defmodule TourinItWeb.TourLive.ShowTest do
  use TourinItWeb.LiveViewCase

  import TourinIt.AccountsFixtures
  import TourinIt.OrganizeFixtures
  import TourinIt.TourGoersFixtures

  defp visit(conn, tour), do: live(conn, ~p"/tours/#{tour.slug}")

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, conn: log_in_user(conn, user), tour: tour_fixture(), user: user}
  end

  test "requires the user to be logged in", %{tour: tour} do
    conn = Phoenix.ConnTest.build_conn()
    {:error, {:redirect, %{to: "/log_in"}}} = visit(conn, tour)
  end

  test "redirects if the user is not invited to any tour sessions", %{
    conn: conn,
    tour: tour
  } do
    {:error, {:redirect, %{to: "/", flash: flash}}} = visit(conn, tour)
    assert flash["error"] == "Could not find #{tour.slug}"
  end

  test "renders a table of tour sessions that the user is invited to", %{
    conn: conn,
    tour: tour,
    user: user
  } do
    first_session = tour_session_fixture(tour, %{identifier: "first session"})
    second_session = tour_session_fixture(tour, %{identifier: "second session"})
    tour_goer_fixture(user, first_session)
    tour_goer_fixture(user, second_session)

    {:ok, view, _html} = visit(conn, tour)

    table_content =
      view
      |> element("tbody#tour_sessions")
      |> render()

    assert table_content =~ first_session.identifier
    assert table_content =~ second_session.identifier
  end
end
