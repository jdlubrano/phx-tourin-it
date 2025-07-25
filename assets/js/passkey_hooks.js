const PasskeyLogInHook = {
  mounted() {
    console.log("PasskeysLogInHook mounted", this);
  }
}

const PasskeyNewHook = {
  mounted() {
    console.log("PasskeysNewHook mounted", this);
  }
}

export { PasskeyLogInHook, PasskeyNewHook };
