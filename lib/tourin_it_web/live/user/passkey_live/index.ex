defmodule TourinItWeb.User.PasskeyLive.Index do
  use TourinItWeb, :live_view

  alias TourinIt.Accounts

  require Logger

  on_mount {TourinItWeb.UserAuth, :mount_current_user}

  def mount(_params, _session, socket) do
    origin = TourinItWeb.Endpoint.url()
    challenge = Wax.new_registration_challenge(origin: origin, rp_id: :auto)

    socket = socket
             |> assign(:challenge_struct, challenge)
             |> assign(:challenge, Base.encode64(challenge.bytes))
             |> assign(:passkey_result, %{status: nil})
             |> assign(:origin, origin)

    {:ok, socket}
  end

  def handle_event("copy_auth_link", _params, socket) do
    encoded_token = Accounts.find_or_create_valid_user_access_token(socket.assigns.current_user)
    auth_link = "#{TourinItWeb.Endpoint.url()}#{~p"/user/passkeys"}?token=#{encoded_token}"

    {:noreply, push_event(socket, "copy", %{value: auth_link})}
  end

  def handle_event("passkey_added", %{"client_data" => client_data, "attestation_object" => attestation_object}, socket) do
    passkey_result = case Wax.register(Base.decode64!(attestation_object), client_data, socket.assigns.challenge_struct) do
      {:ok, {authenticator_data, _attestation_result}} ->
        Logger.info("Wax.register succeeded (user_id: #{socket.assigns.current_user.id})")

        passkey_attrs = %{
          credential_id: authenticator_data.attested_credential_data.credential_id,
          public_key: authenticator_data.attested_credential_data.credential_public_key,
          user_id: socket.assigns.current_user.id
        }

        case Accounts.create_user_passkey(passkey_attrs) do
          {:ok, _passkey} ->
            %{status: :success}

          {:error, changeset} ->
            error_messages = Enum.map(changeset.errors, fn {attr, error_tuple} ->
              "#{attr} #{elem(error_tuple, 0)}"
            end)

            %{status: :error, error: "#{Enum.join(error_messages, ", ")}."}
        end

      {:error, e} ->
        Logger.error("Wax.register error: #{inspect(e)}")
        %{status: :error, error: Exception.message(e)}
    end

    {:noreply, assign(socket, :passkey_result, passkey_result)}
  end
end
