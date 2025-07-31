defmodule TourinItWeb.PageControllerTest do
  use TourinItWeb.ConnCase

  use Gettext, backend: TourinItWeb.Gettext

  import TourinIt.TourGoersFixtures

  describe "GET /" do
    test "shows a message indicating the user is not logged in", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ gettext("page.home.logged_out")
    end

    test "shows a message indicating the user has no tours", %{conn: conn} do
      %{conn: conn} = register_and_log_in_user(%{conn: conn})
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ gettext("page.home.no_tours")
    end

    test "redirects to the user's upcoming tour stop", %{conn: conn} do
      tour_goer = tour_goer_fixture() |> TourinIt.Repo.preload([:user, tour_session: :tour])
      tour_session = tour_goer.tour_session
      tour = tour_session.tour
      user = tour_goer.user

      conn = log_in_user(conn, user)
      conn = get(conn, ~p"/")

      assert redirected_to(conn) == ~p"/tours/#{tour.slug}/#{tour_session.identifier}/upcoming"
    end
  end
end
