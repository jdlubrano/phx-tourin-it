defmodule TourinIt.Accounts.UserPasskey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_passkeys" do
    field :public_key, :binary
    field :credential_id, :binary
    belongs_to :user, TourinIt.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_passkey, attrs) do
    user_passkey
    |> cast(attrs, [:credential_id, :public_key, :user_id])
    |> validate_required([:credential_id, :public_key, :user_id])
  end
end
