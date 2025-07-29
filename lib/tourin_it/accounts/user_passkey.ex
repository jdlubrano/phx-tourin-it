defmodule TourinIt.Accounts.UserPasskey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_passkeys" do
    field :public_key_binary, :binary
    field :credential_id, :binary
    belongs_to :user, TourinIt.Accounts.User

    field :public_key, :map, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_passkey, attrs) do
    attributes = case attrs do
      %{public_key: public_key_map} ->
        Map.put(attrs, :public_key_binary, :erlang.term_to_binary(public_key_map))

      %{"public_key" => public_key_map} ->
        Map.put(attrs, "public_key_binary", :erlang.term_to_binary(public_key_map))

      _ ->
        attrs
    end

    user_passkey
    |> cast(attributes, [:credential_id, :public_key_binary, :user_id])
    |> validate_required([:credential_id, :public_key_binary, :user_id])
    |> unique_constraint([:user_id, :credential_id])
  end
end
