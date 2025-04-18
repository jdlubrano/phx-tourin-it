defmodule TourinItWeb.MeHTML do
  @moduledoc """
  This module contains pages rendered by MeController.

  See the `me_html` directory for all templates available.
  """
  use TourinItWeb, :html

  embed_templates "me_html/*"
end
