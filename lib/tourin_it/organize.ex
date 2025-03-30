defmodule TourinIt.Organize do
  @moduledoc """
  The Organize context.
  """

  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias TourinIt.Repo

  alias TourinIt.Organize.Tour

  @doc """
  Returns the list of tours.

  ## Examples

      iex> list_tours()
      [%Tour{}, ...]

  """
  def list_tours do
    Repo.all(Tour)
  end

  @doc """
  Gets a single tour.

  Raises `Ecto.NoResultsError` if the Tour does not exist.

  ## Examples

      iex> get_tour!(123)
      %Tour{}

      iex> get_tour!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tour!(id), do: Repo.get!(Tour, id)

  @doc """
  Creates a tour.

  ## Examples

      iex> create_tour(%{field: value})
      {:ok, %Tour{}}

      iex> create_tour(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tour(attrs \\ %{}, attempt \\ 0) do
    changeset = change_tour(%Tour{}, attrs)
    name = get_change(changeset, :name)
    changeset = put_change(changeset, :slug, generate_slug(name, attempt))

    result = %Tour{}
             |> Tour.changeset(changeset.changes)
             |> Repo.insert()

    case result do
      {:error, changeset} ->
        if slug_taken?(Enum.at(changeset.errors, 0)) do
          create_tour(attrs, attempt + 1)
        else
          result
        end
      _ -> result
    end
  end

  defp slug_taken?(error) do
    case error do
      {:slug, {_, violation}} -> Keyword.get(violation, :constraint) == :unique
      _ -> false
    end
  end

  defp generate_slug(nil, _), do: nil

  defp generate_slug(name, 0) do
    String.replace(String.downcase(name), ~r{\s+}, "-")
  end

  defp generate_slug(name, attempt) do
    generate_slug(name, 0) <> "-" <> Integer.to_string(attempt)
  end

  @doc """
  Updates a tour.

  ## Examples

      iex> update_tour(tour, %{field: new_value})
      {:ok, %Tour{}}

      iex> update_tour(tour, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tour(%Tour{} = tour, attrs) do
    tour
    |> change_tour(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tour.

  ## Examples

      iex> delete_tour(tour)
      {:ok, %Tour{}}

      iex> delete_tour(tour)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tour(%Tour{} = tour) do
    Repo.delete(tour)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tour changes.

  ## Examples

      iex> change_tour(tour)
      %Ecto.Changeset{data: %Tour{}}

  """
  def change_tour(%Tour{} = tour, attrs \\ %{}) do
    tour
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  alias TourinIt.Organize.TourSession

  @doc """
  Returns the list of tour_sessions.

  ## Examples

      iex> list_tour_sessions()
      [%TourSession{}, ...]

  """
  def list_tour_sessions(tour) do
    TourSession
    |> where([ts], ts.tour_id == ^tour.id)
    |> Repo.all()
  end

  @doc """
  Gets a single tour_session.

  Raises `Ecto.NoResultsError` if the Tour session does not exist.

  ## Examples

      iex> get_tour_session!(123)
      %TourSession{}

      iex> get_tour_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tour_session!(id), do: Repo.get!(TourSession, id)

  @doc """
  Creates a tour_session.

  ## Examples

      iex> create_tour_session(%{field: value})
      {:ok, %TourSession{}}

      iex> create_tour_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tour_session(attrs \\ %{}) do
    %TourSession{}
    |> TourSession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tour_session.

  ## Examples

      iex> update_tour_session(tour_session, %{field: new_value})
      {:ok, %TourSession{}}

      iex> update_tour_session(tour_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tour_session(%TourSession{} = tour_session, attrs) do
    tour_session
    |> TourSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tour_session.

  ## Examples

      iex> delete_tour_session(tour_session)
      {:ok, %TourSession{}}

      iex> delete_tour_session(tour_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tour_session(%TourSession{} = tour_session) do
    Repo.delete(tour_session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tour_session changes.

  ## Examples

      iex> change_tour_session(tour_session)
      %Ecto.Changeset{data: %TourSession{}}

  """
  def change_tour_session(%TourSession{} = tour_session, attrs \\ %{}) do
    TourSession.changeset(tour_session, attrs)
  end
end
