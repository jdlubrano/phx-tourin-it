defmodule TourinItWeb.MeControllerTest do
  use TourinItWeb.ConnCase

  import TourinIt.AccountsFixtures

  describe "GET /me" do
    test "allows authenticated users", %{conn: conn} do
      user = user_fixture()
      conn = get(log_in_user(conn, user), ~p"/me")
      assert html_response(conn, 200) =~ "Welcome"
    end

    test "rejects unauthenticated users", %{conn: conn} do
      conn = get(conn, ~p"/me")
      assert html_response(conn, 403) =~ "You are not authorized"
    end
  end
end
