defmodule TourinItWeb.TourDateLiveTest do
  use TourinItWeb.ConnCase

  import Phoenix.LiveViewTest
  import TourinIt.TourDatesFixtures

  @create_attrs %{date: "2025-05-15"}
  @update_attrs %{date: "2025-05-16"}
  @invalid_attrs %{date: nil}

  defp create_tour_date(_) do
    tour_date = tour_date_fixture()
    %{tour_date: tour_date}
  end

  describe "Index" do
    setup [:create_tour_date]

    test "lists all tour_dates", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/tour_dates")

      assert html =~ "Listing Tour dates"
    end

    test "saves new tour_date", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tour_dates")

      assert index_live |> element("a", "New Tour date") |> render_click() =~
               "New Tour date"

      assert_patch(index_live, ~p"/tour_dates/new")

      assert index_live
             |> form("#tour_date-form", tour_date: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tour_date-form", tour_date: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tour_dates")

      html = render(index_live)
      assert html =~ "Tour date created successfully"
    end

    test "updates tour_date in listing", %{conn: conn, tour_date: tour_date} do
      {:ok, index_live, _html} = live(conn, ~p"/tour_dates")

      assert index_live |> element("#tour_dates-#{tour_date.id} a", "Edit") |> render_click() =~
               "Edit Tour date"

      assert_patch(index_live, ~p"/tour_dates/#{tour_date}/edit")

      assert index_live
             |> form("#tour_date-form", tour_date: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tour_date-form", tour_date: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tour_dates")

      html = render(index_live)
      assert html =~ "Tour date updated successfully"
    end

    test "deletes tour_date in listing", %{conn: conn, tour_date: tour_date} do
      {:ok, index_live, _html} = live(conn, ~p"/tour_dates")

      assert index_live |> element("#tour_dates-#{tour_date.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tour_dates-#{tour_date.id}")
    end
  end

  describe "Show" do
    setup [:create_tour_date]

    test "displays tour_date", %{conn: conn, tour_date: tour_date} do
      {:ok, _show_live, html} = live(conn, ~p"/tour_dates/#{tour_date}")

      assert html =~ "Show Tour date"
    end

    test "updates tour_date within modal", %{conn: conn, tour_date: tour_date} do
      {:ok, show_live, _html} = live(conn, ~p"/tour_dates/#{tour_date}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tour date"

      assert_patch(show_live, ~p"/tour_dates/#{tour_date}/show/edit")

      assert show_live
             |> form("#tour_date-form", tour_date: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#tour_date-form", tour_date: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tour_dates/#{tour_date}")

      html = render(show_live)
      assert html =~ "Tour date updated successfully"
    end
  end
end
