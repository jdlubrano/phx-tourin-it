defmodule TourinItWeb.Organize.TourGoerHTML do
  use TourinItWeb, :html

  embed_templates "tour_goer_html/*"

  @doc """
  Renders a tour goers form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tour_goers_form(assigns)

  def tour_goer_user_options(changeset) do
    selected_user_ids = determine_selected_user_ids(changeset)

    TourinIt.Accounts.list_users()
    |> Enum.map(fn u -> {u.username, u.id, u.id in selected_user_ids} end)
  end

  defp determine_selected_user_ids(changeset) do
    case changeset.action do
      nil ->
        Enum.map(changeset.data.tour_goers, & &1.user_id)

      _ ->
        changeset
        |> Ecto.Changeset.get_change(:tour_goers, [])
        |> Enum.map(fn change -> Map.get(change.changes, :user_id) end)
    end
  end
end
