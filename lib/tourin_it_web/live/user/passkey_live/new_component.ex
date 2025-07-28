defmodule TourinItWeb.Passkeys.NewComponent do
  use TourinItWeb, :live_component

  require Logger

  def mount(socket) do
    origin = "https://localhost:4001"
    challenge = Wax.new_registration_challenge(origin: origin, rp_id: :auto)

    socket = socket
             |> assign(:challenge_struct, challenge)
             |> assign(:challenge, Base.encode64(challenge.bytes))
             |> assign(:origin, origin)

    {:ok, socket}
  end

  def handle_event("passkey_added", %{"client_data" => client_data, "attestation_object" => attestation_object}, socket) do
    case Wax.register(Base.decode64!(attestation_object), client_data, socket.assigns.challenge_struct) do
      {:ok, {authenticator_data, _attestation_result}} ->
        credential_id = authenticator_data.attested_credential_data.credential_id
        public_key = authenticator_data.attested_credential_data.credential_public_key

      {:error, e} ->
        Logger.error("Wax.register error: #{inspect(e)}")
    end

    {:noreply, socket}
  end
end
