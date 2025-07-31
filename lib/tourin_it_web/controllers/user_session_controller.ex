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

  def create(conn, %{
        "authenticator_data" => auth_data_b64,
        "client_data" => client_data,
        "credential_id" => credential_id_b64,
        "signature" => signature_b64
      }) do
    challenge = get_session(conn, :challenge)

    auth_data = Base.decode64!(auth_data_b64)
    credential_id = Base.decode64!(credential_id_b64)
    signature = Base.decode64!(signature_b64)

    passkey = Accounts.get_user_passkey_by_credential_id(credential_id)

    result =
      Wax.authenticate(
        credential_id,
        auth_data,
        signature,
        client_data,
        challenge,
        [{passkey.credential_id, passkey.public_key}]
      )

    case result do
      {:ok, _} ->
        log_in_user(conn, passkey.user, %{"remember_me" => "true"})

      {:error, e} ->
        Logger.error("Wax.authenticate failed: #{inspect(e)}")
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
end
