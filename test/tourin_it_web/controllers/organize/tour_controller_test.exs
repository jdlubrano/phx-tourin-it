defmodule TourinItWeb.Organize.TourControllerTest do
  use TourinItWeb.ConnCase

  import TourinIt.OrganizeFixtures
  alias TourinIt.Organize

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup :create_and_log_in_admin

  describe "index" do
    test "lists all tours", %{conn: conn} do
      conn = get(conn, ~p"/organize/tours")
      assert html_response(conn, 200) =~ "Tours"
    end
  end

  describe "new tour" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/organize/tours/new")
      assert html_response(conn, 200) =~ "New Tour"
    end
  end

  describe "create tour" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/organize/tours", tour: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/organize/tours/#{id}"

      conn = get(conn, ~p"/organize/tours/#{id}")
      tour = Organize.get_tour!(id)
      assert html_response(conn, 200) =~ tour.name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/organize/tours", tour: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tour"
    end
  end

  describe "edit tour" do
    setup [:create_tour]

    test "renders form for editing chosen tour", %{conn: conn, tour: tour} do
      conn = get(conn, ~p"/organize/tours/#{tour}/edit")
      assert html_response(conn, 200) =~ "Edit Tour"
    end
  end

  describe "update tour" do
    setup [:create_tour]

    test "redirects when data is valid", %{conn: conn, tour: tour} do
      conn = put(conn, ~p"/organize/tours/#{tour}", tour: @update_attrs)
      assert redirected_to(conn) == ~p"/organize/tours/#{tour}"

      conn = get(conn, ~p"/organize/tours/#{tour}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, tour: tour} do
      conn = put(conn, ~p"/organize/tours/#{tour}", tour: @invalid_attrs)
      assert html_response(conn, 200) =~ "cannot be blank"
      assert html_response(conn, 200) =~ "Edit Tour"
    end
  end

  describe "delete tour" do
    setup [:create_tour]

    test "deletes chosen tour", %{conn: conn, tour: tour} do
      conn = delete(conn, ~p"/organize/tours/#{tour}")
      assert redirected_to(conn) == ~p"/organize/tours"

      assert_error_sent 404, fn ->
        get(conn, ~p"/organize/tours/#{tour}")
      end
    end
  end

  defp create_tour(_) do
    tour = tour_fixture()
    %{tour: tour}
  end
end
