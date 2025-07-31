defmodule TourinIt.Repo.Migrations.CreateUserPasskeys do
  use Ecto.Migration

  def change do
    create table(:user_passkeys) do
      add :credential_id, :binary, null: false
      add :public_key_binary, :binary, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    # We should require unique passkeys per user, but the passkey flow
    # in the app does not ask for a username.  We need the credential_id
    # to uniquely identify a user. This app is not intended for many users, so
    # we'll hope this works out.  Requiring unique credential_ids is better
    # than letting a user impersonate someone else.
    # create(unique_index(:user_passkeys, [:user_id, :credential_id]))
    create(unique_index(:user_passkeys, [:credential_id]))
  end
end
