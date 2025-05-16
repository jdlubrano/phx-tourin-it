defmodule TourinItWeb.Navbar do
  use TourinItWeb, :html

  def navbar(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8 border-b border-zinc-100">
      <div class="flex items-center justify-between py-3 text-sm">
        <img src={~p"/images/logo.svg"} width="36" />
        <p class="bg-brand/5 text-brand rounded-full px-2 font-medium leading-6">
          v{Application.spec(:tourin_it, :vsn)}
        </p>
      </div>
    </header>
    """
  end
end
