defmodule TourinItWeb.Organize.TourHTML do
  use TourinItWeb, :html

  embed_templates "tour_html/*"

  @doc """
  Renders a tour form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tour_form(assigns)
end
