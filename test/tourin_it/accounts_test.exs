defmodule TourinIt.AccountsTest do
  use TourinIt.DataCase

  alias TourinIt.Accounts

  import TourinIt.AccountsFixtures
  alias TourinIt.Accounts.{User, UserToken}

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_user_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_user_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "create_user_passkey/1" do
    test "creates passkey for the user" do
      user = user_fixture()

      {:ok, passkey} =
        Accounts.create_user_passkey(%{
          credential_id: "test",
          public_key_binary: "test",
          user_id: user.id
        })

      passkey = Repo.preload(passkey, :user)

      assert passkey.credential_id == "test"
      assert passkey.public_key_binary == "test"
      assert passkey.user == user
    end

    test "converts a public_key to binary" do
      user = user_fixture()

      {:ok, passkey} =
        Accounts.create_user_passkey(%{
          credential_id: "test",
          public_key: %{foo: "bar"},
          user_id: user.id
        })

      assert :erlang.binary_to_term(passkey.public_key_binary) == %{foo: "bar"}
    end

    test "rejects invalid attributes" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user_passkey(%{
                 credential_id: "",
                 public_key: "test",
                 user_id: user.id
               })
    end
  end
end
