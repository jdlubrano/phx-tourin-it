defmodule TourinItWeb.UserNotInvitedError do
  defexception [:message]
end

defimpl Plug.Exception, for: TourinItWeb.UserNotInvitedError do
  def status(_exception), do: 404
  def actions(_exception), do: []
end
