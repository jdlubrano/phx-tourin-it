defmodule TourinIt.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :admin, :boolean, default: false
    field :notification_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :notification_url])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  @doc false
  def admin_changeset(user, attrs) do
    changeset(user, attrs)
    |> put_change(:admin, true)
  end
end
