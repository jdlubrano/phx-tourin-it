# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TourinIt.Repo.insert!(%TourinIt.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule TourinIt.Seeds do
  def generate_access_token(admin) when is_binary(admin) do
    {:ok, admin} = TourinIt.Accounts.create_admin(%{username: admin})
    generate_access_token(admin)
  end

  def generate_access_token(admin = %TourinIt.Accounts.User{}) do
    TourinIt.Accounts.generate_user_access_token(admin)
  end
end

admin_username = "admin"
admin = TourinIt.Accounts.get_user_by_username(admin_username)
access_token = TourinIt.Seeds.generate_access_token(admin || admin_username)

IO.puts "Login as #{admin_username} at http://localhost:4000/organize/tours?token=#{access_token}"
