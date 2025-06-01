defmodule TourinIt.TourDates do
  @moduledoc """
  The TourDates context.
  """

  import Ecto.Query, warn: false
  alias TourinIt.Repo

  alias TourinIt.TourDates.{TourDate, TourDateSurvey}
  alias TourinIt.TourGoers.TourGoer

  @doc """
  Returns the list of tour_dates.

  ## Examples

      iex> list_tour_dates()
      [%TourDate{}, ...]

  """
  def list_tour_dates do
    Repo.all(TourDate)
  end

  @doc """
  Gets a single tour_date.

  Raises `Ecto.NoResultsError` if the Tour date does not exist.

  ## Examples

      iex> get_tour_date!(123)
      %TourDate{}

      iex> get_tour_date!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tour_date!(id), do: Repo.get!(TourDate, id)

  @doc """
  Creates a tour_date.

  ## Examples

      iex> create_tour_date(%{field: value})
      {:ok, %TourDate{}}

      iex> create_tour_date(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tour_date(attrs \\ %{}) do
    %TourDate{}
    |> TourDate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tour_date.

  ## Examples

      iex> update_tour_date(tour_date, %{field: new_value})
      {:ok, %TourDate{}}

      iex> update_tour_date(tour_date, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tour_date(%TourDate{} = tour_date, attrs) do
    tour_date
    |> TourDate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tour_date.

  ## Examples

      iex> delete_tour_date(tour_date)
      {:ok, %TourDate{}}

      iex> delete_tour_date(tour_date)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tour_date(%TourDate{} = tour_date) do
    Repo.delete(tour_date)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tour_date changes.

  ## Examples

      iex> change_tour_date(tour_date)
      %Ecto.Changeset{data: %TourDate{}}

  """
  def change_tour_date(%TourDate{} = tour_date, attrs \\ %{}) do
    TourDate.changeset(tour_date, attrs)
  end

  def map_surveys_by_tour_date_and_tour_goer(tour_dates \\ []) do
    Repo.all(surveys_query(tour_dates))
    |> Enum.reduce(%{}, fn s, acc ->
      Map.put(acc, [s.tour_date_id, s.tour_goer_id], s)
    end)
  end

  def load_or_build_surveys(%TourGoer{} = tour_goer, tour_dates \\ []) do
    query = from s in surveys_query(tour_dates), where: s.tour_goer_id == ^tour_goer.id

    existing_surveys = Repo.all(query)
                       |> Enum.reduce(%{}, fn s, acc -> Map.put(acc, s.tour_date_id, s) end)

    tour_dates
    |> Enum.reduce(%{}, fn tour_date, acc ->
      survey = existing_surveys[tour_date.id] || build_survey(tour_goer, tour_date)
      Map.put(acc, tour_date, survey)
    end)
  end

  def upsert_surveys(surveys \\ []) do
    now = DateTime.now!("Etc/UTC") |> DateTime.truncate(:second)

    placeholders = %{timestamp: now}

    surveys = Enum.map(surveys, fn survey ->
      Enum.into(%{inserted_at: {:placeholder, :timestamp}, updated_at: {:placeholder, :timestamp}}, survey)
    end)

    Repo.insert_all(
      TourDateSurvey,
      surveys,
      placeholders: placeholders,
      on_conflict: :replace_all
    )
  end

  defp surveys_query(tour_dates \\ []) do
    tour_date_ids = Enum.map(tour_dates, &(&1.id))

    from s in TourDateSurvey,
      join: td in TourDate, on: s.tour_date_id == td.id,
      where: s.tour_date_id in ^tour_date_ids
  end

  defp build_survey(%TourGoer{} = tour_goer, %TourDate{} = tour_date) do
    Ecto.build_assoc(
      tour_date,
      :tour_date_surveys,
      availability: :tbd,
      tour_goer_id: tour_goer.id
    )
  end
end
