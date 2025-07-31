function base64ToArrayBuffer(base64) {
    var binary_string =  window.atob(base64);
    var len = binary_string.length;
    var bytes = new Uint8Array(len);

    for (var i = 0; i < len; i++) {
      bytes[i] = binary_string.charCodeAt(i);
    }

    return bytes.buffer;
}

function arrayBufferToBase64(buffer) {
  var binary = '';
  var bytes = new Uint8Array(buffer);
  var len = bytes.byteLength;

  for (var i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }

  return window.btoa( binary );
}

function arrayBufferToString(buffer) {
  var binary = '';
  var bytes = new Uint8Array(buffer);
  var len = bytes.byteLength;

  for (var i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }

  return binary;
}

function stringToArrayBuffer(str) {
  const encoder = new TextEncoder();
  const uint8Array = encoder.encode(str);
  return uint8Array.buffer;
}

async function platformAuthenticatorIsAvailable() {
  if (typeof PublicKeyCredential === "undefined" || typeof PublicKeyCredential !== "function") {
    return Promise.resolve(false);
  }

  return PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable();
}

function publicKeyOptions({ userId, username, challenge }) {
  return {
    rp: {
      id: window.location.hostname,
      name: "Tourin' It!",
    },
    user: {
      id: stringToArrayBuffer(userId || ""),
      name: username || "",
      // Required, but we don't have anything better to display than the username.
      displayName: "",
    },
    challenge: base64ToArrayBuffer(challenge),
    pubKeyCredParams: [
      {
        type: "public-key",
        // Ed25519
        alg: -8,
      },
      {
        type: "public-key",
        // ES256
        alg: -7,
      },
      {
        type: "public-key",
        // RS256
        alg: -257,
      },
    ]
  };
}

const PasskeyLogInHook = {
  async mounted() {
    console.info("PasskeysLogInHook mounted", this);
    this.form = this.el;
    this.button = this.form.querySelector("button");

    const available = await platformAuthenticatorIsAvailable();

    if (available) {
      this.button.addEventListener("click", this.askForPasskey.bind(this));
    } else {
      this.form.querySelector(".error").innerHTML = "Passkeys are not available on this device."
      this.form.querySelector("button[type='submit']").disabled = true;
    }
  },

  async askForPasskey() {
    const { challenge, rp } = publicKeyOptions({ challenge: this.form.dataset.challenge });

    const credential = await navigator.credentials.get({
      publicKey: {
        challenge,
        rp,
        allowedCredentials: []
      }
    });

    const { authenticatorData, clientDataJSON, signature } = credential.response;

    this.addHiddenInput({ name: "authenticator_data", value: arrayBufferToBase64(authenticatorData) });
    this.addHiddenInput({ name: "client_data", value: arrayBufferToString(clientDataJSON) });
    this.addHiddenInput({ name: "credential_id", value: arrayBufferToBase64(credential.rawId) });
    this.addHiddenInput({ name: "signature", value: arrayBufferToBase64(signature) });

    this.form.submit();
  },

  addHiddenInput({ name, value }) {
    let input = document.createElement("input");
    input.type = "hidden";
    input.name = name;
    input.value = value;

    this.form.appendChild(input);
  }
}

const PasskeyNewHook = {
  async mounted() {
    console.info("PasskeysNewHook mounted", this);
    this.button = this.el.querySelector("button");
    this.error = this.el.querySelector(".error");

    const available = await platformAuthenticatorIsAvailable();

    if (available) {
      this.button.addEventListener("click", this.registerPasskey.bind(this));
    } else {
      this.button.remove();
      this.error.innerHTML = "Passkeys are not available on this device."
    }
  },

  async registerPasskey() {
    try {
      const { challenge, username, "user-id": userId } = this.el.dataset;

      const credential = await navigator.credentials.create({
        publicKey: publicKeyOptions({ userId, username, challenge })
      });

      this.pushEventTo(this.el, "passkey_added", {
        attestation_object: arrayBufferToBase64(credential.response.attestationObject),
        client_data: arrayBufferToString(credential.response.clientDataJSON),
      });
    } catch(e) {
      console.error("startRegistration error", e);
      this.error.textContent = e.toString();
      return;
    }
  },
}

export { PasskeyLogInHook, PasskeyNewHook };
