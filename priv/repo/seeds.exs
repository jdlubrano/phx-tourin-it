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
env_seeds = "#{Path.dirname(__ENV__.file)}/seeds/#{Mix.env()}.exs"

if File.exists?(env_seeds) do
  IO.puts("Loading #{env_seeds}")
  Code.require_file(env_seeds)
else
  IO.puts("No seeds file found at #{env_seeds}")
end
