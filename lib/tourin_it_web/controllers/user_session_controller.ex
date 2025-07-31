defmodule TourinItWeb.UserSessionController do
  use TourinItWeb, :controller

  import TourinItWeb.UserAuth

  require Logger

  alias TourinIt.Accounts

  plug TourinItWeb.Plugs.UpcomingTourStop when action in [:new]

  def new(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/")
    else
      render(setup_webauthn(conn), :new, error: nil)
    end
  end

  def create(conn, %{"credential_id" => credential_id_b64} = params) do
    credential_id = Base.decode64!(credential_id_b64)
    passkey = Accounts.get_user_passkey_by_credential_id(credential_id)

    case verify_passkey(conn, passkey, credential_id, params) do
      {:ok, _} ->
        log_in_user(conn, passkey.user, %{"remember_me" => "true"})

      {:error, e} ->
        Logger.error("verify_passkey failed: #{inspect(e)}")
        render(setup_webauthn(conn), :new, error: "Log in failed")
    end
  end

  def destroy(conn, _params) do
    log_out_user(conn)
  end

  defp setup_webauthn(conn) do
    origin = TourinItWeb.Endpoint.url()
    challenge = Wax.new_registration_challenge(origin: origin, rp_id: :auto)

    put_session(conn, :challenge, challenge)
    |> assign(:challenge, Base.encode64(challenge.bytes))
  end

  defp verify_passkey(_conn, nil, _, _), do: {:error, "Could not find matching passkey"}

  defp verify_passkey(conn, passkey, credential_id, %{
         "authenticator_data" => auth_data_b64,
         "client_data" => client_data,
         "signature" => signature_b64
       }) do
    challenge = get_session(conn, :challenge)

    auth_data = Base.decode64!(auth_data_b64)
    signature = Base.decode64!(signature_b64)

    Wax.authenticate(
      credential_id,
      auth_data,
      signature,
      client_data,
      challenge,
      [{passkey.credential_id, passkey.public_key}]
    )
  end
end
