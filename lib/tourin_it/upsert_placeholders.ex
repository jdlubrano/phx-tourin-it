defmodule TourinIt.UpsertPlaceholders do
  def timestamp_placeholders(opts \\ []) do
    fields = Keyword.get(opts, :fields, [:inserted_at, :updated_at])
    time = Keyword.get(opts, :time, DateTime.now!("Etc/UTC")) |> DateTime.truncate(:second)

    attrs = Enum.reduce(fields, %{}, fn field, placeholders ->
      Map.put(placeholders, field, {:placeholder, :timestamp})
    end)

    {%{timestamp: time}, attrs}
  end
end
