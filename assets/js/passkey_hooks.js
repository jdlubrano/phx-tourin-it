function base64ToArrayBuffer(base64) {
    var binary_string =  window.atob(base64);
    var len = binary_string.length;
    var bytes = new Uint8Array(len);

    for (var i = 0; i < len; i++)        {
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
    return new Promise((resolve) => resolve(false));
  }

  return PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable();
}

function registrationOptions({ userId, username, challenge }) {
  return {
    rp: {
      id: window.location.hostname,
      name: "Tourin' It!",
    },
    user: {
      id: userId,
      name: username,
      // Required, but we don't have anything better to display than the username.
      displayName: "",
    },
    challenge: challenge,
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
  mounted() {
    console.log("PasskeysLogInHook mounted", this);
  }
}

const PasskeyNewHook = {
  async mounted() {
    console.log("PasskeysNewHook mounted", this);
    this.button = this.el.querySelector("button");
    this.error = this.el.querySelector(".error");

    const available = await platformAuthenticatorIsAvailable();

    if (available) {
      const userId = stringToArrayBuffer(this.el.dataset["user-id"]);
      const username = this.el.dataset.username;
      const challenge = base64ToArrayBuffer(this.el.dataset.challenge);

      this.credentialOptions = {
        publicKey: registrationOptions({ userId, username, challenge })
      };

      this.button.addEventListener("click", this.registerPasskey.bind(this));
    }
  },

  async registerPasskey() {
    try {
      const credential = await navigator.credentials.create(this.credentialOptions);

      this.pushEventTo(this.el, "passkey_added", {
        attestation_object: arrayBufferToBase64(credential.response.attestationObject),
        client_data: arrayBufferToString(credential.response.clientDataJSON),
      });
    } catch(e) {
      console.error("startRegistration error", e);
      this.error.innerHTML = e;
      return;
    }
  },
}

export { PasskeyLogInHook, PasskeyNewHook };
