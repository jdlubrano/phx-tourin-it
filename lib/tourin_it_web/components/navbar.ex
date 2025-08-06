defmodule TourinItWeb.Navbar do
  use TourinItWeb, :html

  attr :current_user, :any, required: true

  def navbar(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8 border-b border-zinc-100">
      <div class="flex items-center justify-between py-3 text-sm">
        <.link navigate={~p"/"}>
          <img src={~p"/images/logo.svg"} width="36" />
        </.link>
        <div class="inline-flex font-medium leading-6 relative">
          <button
            :if={@current_user}
            class="capitalize cursor-pointer mr-4 peer"
            type="button"
            phx-click={JS.focus()}
          >
            Hello, {@current_user.username}
            <.icon name="hero-chevron-down" class="size-3" />
          </button>

          <ul class="hidden peer-focus:block has-[:active]:block absolute left-0 top-6 rounded-md drop-shadow-md bg-zinc-100 w-full">
            <li>
              <.link
                navigate={~p"/user/passkeys"}
                class="inline-block p-2 hover:bg-zinc-200 rounded-md w-full"
              >
                Passkeys
              </.link>
            </li>
            <li>
              <.link
                href={~p"/log_out"}
                method="delete"
                class="inline-block p-2 hover:bg-zinc-200 rounded-md w-full"
              >
                Log out
              </.link>
            </li>
          </ul>

          <.link
            :if={@current_user && @current_user.admin}
            class="underline mr-4"
            navigate={~p"/organize/tours"}
          >
            Admin
          </.link>
          <a
            href="https://github.com/jdlubrano/phx-tourin-it/releases"
            target="_blank"
            rel="noopener noreferer"
          >
            <span class="bg-brand/5 text-brand rounded-full px-2">
              v{Application.spec(:tourin_it, :vsn)}
            </span>
          </a>
        </div>
      </div>
    </header>
    """
  end
end
