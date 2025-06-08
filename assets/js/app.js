// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

window.addEventListener("phx:copy", (event) => {
  const copied = event.detail.value;
  navigator.clipboard.writeText(copied);

  let copiedNotification = document.createElement("div");

  copiedNotification.classList.add(
    "fixed",
    "top-3",
    "w-full",
    "flex",
    "justify-center",
    "transition-all",
    "delay-1000"
  );

  copiedNotification.innerHTML = `<span class="rounded-lg p-3 text-sm bg-green-50">Copied ${copied}</span>`;

  document.body.appendChild(copiedNotification);

  setTimeout(() => copiedNotification.classList.add("opacity-0"));
});

function hideTooltip(element) {
  const tooltipContent = element.dataset && element.dataset["tooltip"];

  if (!tooltipContent) {
    return;
  }

  const tooltip = document.body.querySelector(".tooltip")

  if (tooltip) {
    tooltip.remove();
  }
}

function showTooltip(element) {
  const tooltipContent = element.dataset && element.dataset["tooltip"];

  if (!tooltipContent) {
    return;
  }

  const boundingBox = element.getBoundingClientRect();

  let tooltip = document.createElement("div");

  tooltip.classList.add(
    "absolute",
    "rounded-lg",
    "bg-gray-100",
    "p-2",
    "mt-1",
    "text-center",
    "text-sm",
    "tooltip",
    "z-99"
  );

  const width = 120;
  const left = window.scrollX + (boundingBox.right + boundingBox.left - width) / 2;
  const top = window.scrollY + boundingBox.bottom;

  tooltip.style.width = `${width}px`;
  tooltip.style.left = `${left}px`;
  tooltip.style.top = `${top}px`;
  tooltip.textContent = tooltipContent;

  document.body.appendChild(tooltip);
}

window.addEventListener("focusin", (event) => showTooltip(event.target));
window.addEventListener("focusout", (event) => hideTooltip(event.target));
window.addEventListener("mouseover", (event) => showTooltip(event.target));
window.addEventListener("mouseout", (event) => hideTooltip(event.target));
