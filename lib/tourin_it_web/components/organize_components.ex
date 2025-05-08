defmodule TourinItWeb.OrganizeComponents do
  use TourinItWeb, :html

  attr :tour_goers, :list, required: true
  attr :user_access_tokens, :map, default: %{}
  def tour_goers_table(assigns) do
    ~H"""
    <.table id="tour_goers" rows={@tour_goers}>
      <:title>
        <p class="mb-6 leading-6 text-zinc-800">Tour goers</p>
      </:title>
      <:col :let={tg} label="Username">{tg.user.username}</:col>
      <:col :let={tg} label="Access token">
        <span :if={@user_access_tokens[tg.user_id]}>
          {@user_access_tokens[tg.user_id].encoded_token}
        </span>
      </:col>
      <:action :let={tg}>
        <button type="button" phx-click="generate_access_token" phx-value-user_id={tg.user_id}
          class={[
            "phx-submit-loading:opacity-75 rounded-lg bg-green-200 hover:bg-green-100 py-1 px-2",
            "text-sm font-semibold leading-6 text-zinc-700 active:text-zinc-700/80",
          ]}
        >
          Generate access token
        </button>
      </:action>
    </.table>
    """
  end
end
