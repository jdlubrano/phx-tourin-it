defmodule TourinItWeb.TourLive.IndexTest do
  use TourinItWeb.LiveViewCase

  import TourinIt.AccountsFixtures
  import TourinIt.OrganizeFixtures
  import TourinIt.TourGoersFixtures

  alias TourinIt.Repo

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, conn: log_in_user(conn, user), user: user}
  end

  test "requires the user to be logged in" do
    conn = Phoenix.ConnTest.build_conn()
    {:error, {:redirect, %{to: "/log_in"}}} = live(conn, ~p"/tours")
  end

  test "renders an empty state if the user has access to no tours", %{
    conn: conn
  } do
    {:ok, _view, html} = live(conn, ~p"/tours")
    assert html =~ gettext("page.home.no_tours")
  end

  test "renders the tours the user has access to", %{
    conn: conn,
    user: user
  } do
    tour_session = tour_session_fixture() |> Repo.preload(:tour)
    tour_goer_fixture(user, tour_session)
    {:ok, view, _html} = live(conn, ~p"/tours")

    table_content =
      view
      |> element("tbody#tours")
      |> render()

    assert table_content =~ tour_session.tour.name
  end
end
