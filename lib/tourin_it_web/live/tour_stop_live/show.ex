defmodule TourinItWeb.TourStopLive.Show do
  use TourinItWeb, :live_view

  alias TourinIt.Repo
  alias TourinIt.{Accounts, Organize, TourDates, TourGoers ,TourStops}
  alias TourinIt.TourDates.TourDate
  alias TourinIt.TourGoers.TourGoer
  alias TourinIt.TourStops.TourStop

  @availability_classes %{
    "available"   => ["capitalize", "bg-green-100"],
    "tbd"         => ["uppercase", "bg-yellow-100"],
    "unavailable" => ["capitalize", "bg-red-100"]
  }

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def mount(%{"tour_slug" => slug, "tour_session_identifier" => identifier}, _session, socket) do
    tour_session = Organize.get_tour_session!(%{identifier: identifier, slug: slug})
    ensure_invited!(socket.assigns.current_user, tour_session)

    tour_session = Repo.preload(tour_session, [:tour, tour_goers: :user])
    tour_stop = TourStops.upcoming(tour_session.id) |> Repo.preload(:tour_dates)
    tour_goers = Enum.sort_by(tour_session.tour_goers, &(&1.user.username), :asc)
    surveys = TourDates.map_surveys_by_tour_date_and_tour_goer(tour_stop.tour_dates)

    socket =
      socket
      |> assign(:tour_session, tour_session)
      |> assign(:tour_stop, tour_stop)
      |> assign(:tour_goers, tour_goers)
      |> assign(:surveys, surveys)

    {:ok, socket}
  end

  defp ensure_invited!(current_user, tour_session) do
    unless invited?(current_user, tour_session) || Accounts.admin?(current_user) do
      raise TourinItWeb.UserNotInvitedError, "User ##{current_user.id} not invited to TourSession ##{tour_session.id}"
    end
  end

  defp invited?(current_user, tour_session), do: TourGoers.invited?(current_user.id, tour_session.id)

  defp availability(surveys, %TourDate{} = tour_date, %TourGoer{} = tour_goer) do
    survey = Map.get(surveys, [tour_date.id, tour_goer.id])

    if is_nil(survey), do: "tbd", else: survey.availability
  end

  defp availability_classes(surveys, %TourDate{} = tour_date, %TourGoer{} = tour_goer) do
    [
      "overflow-hidden",
      "text-center",
      "text-ellipsis",
      "mx-1",
      "py-1",
      "px-2",
      "rounded-md"
    ] ++ @availability_classes[availability(surveys, tour_date, tour_goer)]
  end
end
