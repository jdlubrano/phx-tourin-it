defmodule TourinItWeb.TourStopLive.Show do
  use TourinItWeb, :live_view

  import TourinItWeb.Access.TourGoer
  import TourinItWeb.TourStopComponents

  alias TourinIt.Repo
  alias TourinIt.{TourDates, TourGoers, TourStops}
  alias TourinIt.TourDates.TourDateSurvey

  @availability_classes %{
    available: ["capitalize", "bg-green-100", "focus:ring-green-200"],
    tbd: ["uppercase", "bg-yellow-100", "focus:ring-yellow-200"],
    unavailable: ["capitalize", "bg-red-100", "focus:ring-red-200"]
  }

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def mount(%{"id" => id}, _session, socket) do
    tour_stop =
      TourStops.get_tour_stop!(id) |> Repo.preload([:guest_picker, :tour_dates, :tour_session])

    ensure_invited!(socket.assigns.current_user, tour_stop.tour_session)

    tour_session = Repo.preload(tour_stop.tour_session, [:tour, tour_goers: :user])
    tour_goers = Enum.sort_by(tour_session.tour_goers, & &1.user.username, :asc)

    surveys =
      TourDates.map_surveys_by_tour_date_and_tour_goer((tour_stop && tour_stop.tour_dates) || [])

    socket =
      socket
      |> assign(:page_title, "#{tour_session.tour.name} #{tour_session.identifier}")
      |> assign(:tour_session, tour_session)
      |> assign(:tour_stop, tour_stop)
      |> assign(:tour_goers, tour_goers)
      |> assign(:surveys, surveys)

    {:ok, socket}
  end

  defp invited?(current_user, tour_session),
    do: TourGoers.invited?(current_user.id, tour_session.id)

  defp guest_picker?(tour_stop, current_user),
    do: TourStops.guest_picker?(tour_stop, current_user)

  defp surveys_for(surveys, tour_goer, tour_dates) do
    Enum.map(tour_dates, fn tour_date ->
      Map.get(surveys, [tour_date.id, tour_goer.id]) || %TourDateSurvey{availability: :tbd}
    end)
  end

  defp availability_classes(%TourDateSurvey{} = survey) do
    [
      "overflow-hidden",
      "text-center",
      "text-ellipsis",
      "mx-1",
      "py-1",
      "px-2",
      "relative",
      "rounded-md",
      "focus:ring"
    ] ++ @availability_classes[survey.availability]
  end
end
