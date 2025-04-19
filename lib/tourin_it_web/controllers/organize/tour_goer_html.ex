defmodule TourinItWeb.Organize.TourGoerHTML do
  use TourinItWeb, :html

  embed_templates "tour_goer_html/*"

  @doc """
  Renders a tour goers form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tour_goers_form(assigns)
end
