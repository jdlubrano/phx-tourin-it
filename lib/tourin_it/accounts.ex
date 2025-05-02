defmodule TourinIt.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TourinIt.Repo

  alias TourinIt.Accounts.{User, UserToken}

  ## Database getters
  def get_user_by_access_token(nil), do: nil

  def get_user_by_access_token(token) do
    {:ok, decoded_token} = Base.url_decode64(token, padding: false)
    {:ok, query} = UserToken.verify_access_token_query(decoded_token)
    Repo.one(query)
  end

  def generate_user_access_token(user) do
    {token, user_token} = UserToken.build_access_token(user)
    Repo.insert!(user_token)
    Base.url_encode64(token, padding: false)
  end

  @doc """
  Gets a user by username.

  ## Examples

      iex> get_user_by_username("foo")
      %User{}

      iex> get_user_by_username("unknown")
      nil

  """
  def get_user_by_username(username) when is_binary(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def list_users do
    Repo.all(from u in TourinIt.Accounts.User, order_by: u.username)
  end

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_admin(attrs) do
    %User{}
    |> User.admin_changeset(attrs)
    |> Repo.insert()
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end
end
