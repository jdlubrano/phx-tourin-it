defmodule TourinItWeb.Organize.AdminAccessTest do
  use TourinItWeb.ConnCase

  import TourinIt.AccountsFixtures

  describe "admin access" do
    test "admins can access organize pages", %{conn: conn} do
      admin = admin_user_fixture()
      conn = get(log_in_user(conn, admin), ~p"/organize/tours")
      assert html_response(conn, 200) =~ "Tours"
    end

    test "admins can access organize pages with a token", %{conn: conn} do
      admin = admin_user_fixture()
      token = TourinIt.Accounts.generate_user_access_token(admin)
      conn = get(conn, ~p"/organize/tours?token=#{token}")
      assert html_response(conn, 200) =~ "Tours"
    end

    test "only admins can access organize pages", %{conn: conn} do
      user = user_fixture()
      conn = get(log_in_user(conn, user), ~p"/organize/tours")
      assert redirected_to(conn) =~ ~p"/"
    end
  end
end
