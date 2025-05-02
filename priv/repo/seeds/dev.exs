defmodule TourinIt.Seeds.Dev do
  require Logger

  alias TourinIt.Accounts
  alias TourinIt.Accounts.User
  alias TourinIt.Repo

  def find_or_create_user(username) do
    user = Accounts.get_user_by_username(username)

    if is_nil(user) do
      {:ok, user} = Accounts.register_user(%{username: username})
      Logger.info("Created User #{user.id} for #{username}")
      user
    else
      Logger.info("User #{user.id} exists for #{username}")
      user
    end
  end

  def find_or_create_admin(username) do
    {:ok, admin} = find_or_create_user(username)
                   |> User.admin_changeset(%{})
                   |> Repo.update()

    admin
  end

  def generate_access_token(user = %TourinIt.Accounts.User{}) do
    access_token = Accounts.generate_user_access_token(user)
    Logger.info("Login as #{user.username} at http://localhost:4000/organize/tours?token=#{access_token}")
  end
end

Enum.each(["andrew", "scott"], &TourinIt.Seeds.Dev.find_or_create_user/1)

admin = TourinIt.Seeds.Dev.find_or_create_admin("admin")
TourinIt.Seeds.Dev.generate_access_token(admin)
