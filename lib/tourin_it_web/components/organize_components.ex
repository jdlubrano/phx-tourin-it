defmodule TourinItWeb.OrganizeComponents do
  use TourinItWeb, :html

  attr :tour_goers, :list, required: true
  attr :tour_goers_access_tokens, :map, default: %{}
  def tour_goers_table(assigns) do
    ~H"""
    <.table id="tour_goers" rows={@tour_goers}>
      <:title>
        <p class="mb-6 leading-6 text-zinc-800">Tour goers</p>
      </:title>
      <:col :let={tg} label="Username">{tg.user.username}</:col>
      <:action :let={_tg}>
        <button phx-click="generate_access_token">Generate access token</button>
      </:action>
    </.table>
    """
  end
end
