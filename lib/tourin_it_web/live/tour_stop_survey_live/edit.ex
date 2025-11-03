defmodule TourinItWeb.TourStopSurveyLive.Edit do
  use TourinItWeb, :live_view

  import TourinItWeb.Access.TourGoer
  import TourinItWeb.TourStopComponents

  alias TourinIt.{Repo, TourDates, TourGoers, TourStops}

  def mount(%{"id" => id}, _session, socket) do
    tour_stop =
      TourStops.get_tour_stop!(id)
      |> Repo.preload(guest_picker: :user)

    ensure_invited!(socket.assigns.current_user, tour_stop.tour_session_id)

    tour_stop = Repo.preload(tour_stop, [:tour_dates, tour_session: :tour])

    tour_goer =
      TourGoers.get_tour_goer!(socket.assigns.current_user.id, tour_stop.tour_session_id)

    surveys = TourDates.load_or_build_surveys(tour_goer, tour_stop.tour_dates)

    socket =
      socket
      |> assign(
        :page_title,
        "#{tour_stop.tour_session.tour.name} #{tour_stop.tour_session.identifier}"
      )
      |> assign(:surveys, surveys)
      |> assign(:tour_goer, tour_goer)
      |> assign(:tour_stop, tour_stop)

    {:ok, socket}
  end

  def handle_event("save", %{"tour_stop" => %{"tour_date_surveys" => surveys_params}}, socket) do
    surveys =
      Enum.map(surveys_params, fn {_tour_date_id, survey_params} ->
        survey_params = Enum.into(%{"tour_goer_id" => socket.assigns.tour_goer.id}, survey_params)

        changes =
          TourDates.change_tour_date_survey(%TourDates.TourDateSurvey{}, survey_params).changes

        Map.put_new(changes, :note, nil)
      end)

    TourDates.upsert_surveys(surveys)

    socket =
      socket
      |> put_flash(:info, "Availability submitted!")
      |> push_navigate(to: ~p"/tour_stops/#{socket.assigns.tour_stop}")

    {:noreply, socket}
  end
end
