defmodule TourinItWeb.LiveViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use TourinItWeb.ConnCase
      import TourinItWeb.LiveViewCase
      use Gettext, backend: TourinItWeb.Gettext

      import Phoenix.LiveViewTest
    end
  end
end
