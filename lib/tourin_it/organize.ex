defmodule TourinIt.Organize do
  @moduledoc """
  The Organize context.
  """

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
    name = Map.get(attrs, :name)
    attrs_with_slug = Map.put(attrs, :slug, generate_slug(name, attempt))

    result = %Tour{}
             |> Tour.changeset(attrs_with_slug)
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
    |> Tour.changeset(Map.delete(attrs, :slug))
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
    Tour.changeset(tour, attrs)
  end
end
