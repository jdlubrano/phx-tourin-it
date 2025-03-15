defmodule TourinIt.Repo do
  use Ecto.Repo,
    otp_app: :tourin_it,
    adapter: Ecto.Adapters.SQLite3
end
