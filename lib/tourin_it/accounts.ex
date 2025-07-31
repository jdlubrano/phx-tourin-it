defmodule TourinIt.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TourinIt.Repo

  alias TourinIt.Accounts.{User, UserPasskey, UserToken}

  ## Database getters
  def get_user_by_access_token(nil), do: nil

  def get_user_by_access_token(token) do
    {:ok, decoded_token} = Base.url_decode64(token, padding: false)
    {:ok, query} = UserToken.verify_access_token_query(decoded_token)
    Repo.one(query)
  end

  def find_or_create_valid_user_access_token(user) do
    query = UserToken.valid_access_token_for_user_query(user)
    token = Repo.one(query) || generate_user_access_token(user)

    encode_token(token.token)
  end

  def generate_user_access_token(user) do
    {token, user_token} = UserToken.build_access_token(user)
    Repo.insert!(user_token)
    encode_token(token)
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

  def admin?(user = %User{}) do
    Repo.exists?(from u in User, where: u.admin == true and u.id == ^user.id)
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

  def newest_tokens_for_users(user_ids, tokens_context \\ "access") do
    query =
      from t in UserToken,
        left_join: t2 in UserToken,
        on:
          t.user_id == t2.user_id and t.context == t2.context and t.inserted_at < t2.inserted_at,
        where: t.user_id in ^user_ids and t.context == ^tokens_context and is_nil(t2.id),
        select: t

    query
    |> Repo.all()
    |> Enum.reduce(%{}, fn t, tokens ->
      val = Map.merge(t, %{encoded_token: encode_token(t.token)})
      Map.merge(tokens, %{t.user_id => val})
    end)
  end

  defp encode_token(token) do
    Base.url_encode64(token, padding: false)
  end

  def create_user_passkey(attrs) do
    %UserPasskey{}
    |> UserPasskey.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_passkey_by_credential_id(credential_id) do
    query =
      from p in UserPasskey,
        where: p.credential_id == ^credential_id,
        order_by: [asc: :id],
        limit: 1

    passkey = Repo.one(query) |> Repo.preload(:user)

    if passkey do
      Map.put(passkey, :public_key, :erlang.binary_to_term(passkey.public_key_binary))
    else
      nil
    end
  end
end
