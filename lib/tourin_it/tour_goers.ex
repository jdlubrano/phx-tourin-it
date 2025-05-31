defmodule TourinIt.TourGoers do
  @moduledoc """
  The TourGoers context.
  """

  import Ecto.Query, warn: false
  alias TourinIt.Repo

  alias TourinIt.TourGoers.TourGoer

  def invited?(user_id, tour_session_id) do
    Repo.exists?(invited_query(user_id, tour_session_id))
  end

  defp invited_query(user_id, tour_session_id) do
    from tg in TourGoer, where: tg.user_id == ^user_id and tg.tour_session_id == ^tour_session_id
  end

  @doc """
  Gets a single tour_goer.

  Raises `Ecto.NoResultsError` if the Tour goer does not exist.

  ## Examples

      iex> get_tour_goer!(123)
      %TourGoer{}

      iex> get_tour_goer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tour_goer!(id), do: Repo.get!(TourGoer, id)

  def get_tour_goer!(user_id, tour_session_id) do
    Repo.one!(invited_query(user_id, tour_session_id))
  end

  @doc """
  Creates a tour_goer.

  ## Examples

      iex> create_tour_goer(%{field: value})
      {:ok, %TourGoer{}}

      iex> create_tour_goer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tour_goer(attrs \\ %{}) do
    %TourGoer{}
    |> TourGoer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a tour_goer.

  ## Examples

      iex> delete_tour_goer(tour_goer)
      {:ok, %TourGoer{}}

      iex> delete_tour_goer(tour_goer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tour_goer(%TourGoer{} = tour_goer) do
    Repo.delete(tour_goer)
  end
end
