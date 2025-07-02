defmodule TourinItWeb.Navbar do
  use TourinItWeb, :html

  attr :current_user, :any, required: true

  def navbar(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8 border-b border-zinc-100">
      <div class="flex items-center justify-between py-3 text-sm">
        <img src={~p"/images/logo.svg"} width="36" />
        <p class="font-medium leading-6">
          <span :if={@current_user} class="capitalize mr-4">Hello, {@current_user.username}</span>
          <.link :if={@current_user && @current_user.admin} class="underline mr-4" navigate={~p"/organize/tours"}>Admin</.link>
          <span class="bg-brand/5 text-brand rounded-full px-2">
            v{Application.spec(:tourin_it, :vsn)}
          </span>
        </p>
      </div>
    </header>
    """
  end
end
