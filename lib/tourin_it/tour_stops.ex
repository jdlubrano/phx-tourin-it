defmodule TourinIt.TourStops do
  @moduledoc """
  The TourStops context.
  """

  import Ecto.Query, warn: false
  alias TourinIt.Repo

  alias TourinIt.TourDates.TourDate
  alias TourinIt.TourStops.TourStop

  def upcoming(tour_session_id) do
    {:ok, now} = DateTime.now("America/New_York")
    today = DateTime.to_date(now)

    query =
      from tour_stop in TourStop,
        where: tour_stop.tour_session_id == ^tour_session_id and tour_stop.end_date >= ^today,
        order_by: tour_stop.end_date,
        limit: 1

    Repo.one(query)
  end

  def past_and_upcoming(tour_session_id) do
    up = upcoming(tour_session_id)

    query =
      from tour_stop in TourStop,
        where:
          tour_stop.tour_session_id == ^tour_session_id and tour_stop.end_date <= ^up.end_date,
        order_by: [desc: tour_stop.end_date]

    Repo.all(query)
  end

  @doc """
  Returns the list of tour_stops.

  ## Examples

      iex> list_tour_stops()
      [%TourStop{}, ...]

  """
  def list_tour_stops do
    Repo.all(TourStop)
  end

  @doc """
  Gets a single tour_stop.

  Raises `Ecto.NoResultsError` if the Tour stop does not exist.

  ## Examples

      iex> get_tour_stop!(123)
      %TourStop{}

      iex> get_tour_stop!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tour_stop!(id), do: Repo.get!(TourStop, id)

  @doc """
  Creates a tour_stop.

  ## Examples

      iex> create_tour_stop(%{field: value})
      {:ok, %TourStop{}}

      iex> create_tour_stop(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tour_stop(attrs \\ %{}) do
    %TourStop{}
    |> TourStop.changeset(attrs)
    |> Repo.insert()
  end

  def create_tour_stop_with_dates(attrs \\ %{}) do
    Repo.transaction(fn ->
      case create_tour_stop(attrs) do
        {:ok, tour_stop} ->
          set_tour_dates(tour_stop)

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  def set_tour_dates(tour_stop = %TourStop{}) do
    date_range = Date.range(tour_stop.start_date, tour_stop.end_date)

    {placeholders, placeholder_attrs} = TourinIt.UpsertPlaceholders.timestamp_placeholders()

    tour_dates =
      Enum.map(
        date_range,
        &Enum.into(
          %{date: &1, tour_stop_id: tour_stop.id},
          placeholder_attrs
        )
      )

    Repo.insert_all(
      TourDate,
      tour_dates,
      placeholders: placeholders,
      on_conflict: :nothing,
      conflict_target: [:date, :tour_stop_id]
    )

    Repo.delete_all(
      from td in TourDate,
        where: td.tour_stop_id == ^tour_stop.id and td.date not in ^Enum.to_list(date_range)
    )

    tour_stop
  end

  @doc """
  Updates a tour_stop.

  ## Examples

      iex> update_tour_stop(tour_stop, %{field: new_value})
      {:ok, %TourStop{}}

      iex> update_tour_stop(tour_stop, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tour_stop(%TourStop{} = tour_stop, attrs) do
    tour_stop
    |> TourStop.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tour_stop.

  ## Examples

      iex> delete_tour_stop(tour_stop)
      {:ok, %TourStop{}}

      iex> delete_tour_stop(tour_stop)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tour_stop(%TourStop{} = tour_stop) do
    Repo.delete(tour_stop)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tour_stop changes.

  ## Examples

      iex> change_tour_stop(tour_stop)
      %Ecto.Changeset{data: %TourStop{}}

  """
  def change_tour_stop(%TourStop{} = tour_stop, attrs \\ %{}) do
    TourStop.changeset(tour_stop, attrs)
  end
end
