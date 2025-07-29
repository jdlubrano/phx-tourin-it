defmodule TourinIt.Repo.Migrations.CreateUserPasskeys do
  use Ecto.Migration

  def change do
    create table(:user_passkeys) do
      add :credential_id, :binary, null: false
      add :public_key_binary, :binary, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:user_passkeys, [:user_id, :credential_id]))
  end
end
