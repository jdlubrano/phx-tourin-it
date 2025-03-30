defmodule TourinItWeb.Organize.TourSessionHTML do
  use TourinItWeb, :html

  embed_templates "tour_session_html/*"

  @doc """
  Renders a tour form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tour_session_form(assigns)
end
