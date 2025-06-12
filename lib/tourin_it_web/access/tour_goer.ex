defmodule TourinItWeb.Access.TourGoer do

  alias TourinIt.Accounts
  alias TourinIt.Accounts.User

  alias TourinIt.Organize.TourSession

  alias TourinIt.TourGoers

  alias TourinItWeb.UserNotInvitedError

  def ensure_invited!(%User{} = current_user, %TourSession{} = tour_session) do
    unless TourGoers.invited?(current_user.id, tour_session.id) || Accounts.admin?(current_user) do
      raise UserNotInvitedError, "User ##{current_user.id} not invited to TourSession ##{tour_session.id}"
    end
  end

  def ensure_invited!(%User{} = current_user, tour_session_id) do
    unless TourGoers.invited?(current_user.id, tour_session_id) || Accounts.admin?(current_user) do
      raise UserNotInvitedError, "User ##{current_user.id} not invited to TourSession ##{tour_session_id}"
    end
  end
end
