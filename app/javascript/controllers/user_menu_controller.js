import BaseController from "controllers/base_controller";

export default class extends BaseController {
  static targets = [
    "menuNav",
    "spMenuBtn",
    "loginZumiMenu",
    "loginZumiPcMenu",
    "loginZumiSpMenu",
    "MiLoginMenu",
  ];

  toggle() {
    if (this.spMenuBtnTarget.classList.contains("opened")) this.#hideModal();
    else this.#showModal();
  }

  switchLoginForm() {
    this.#hideModal();
    this.dispatchLoginForm();
  }

  dispatchLogoutUser() {
    window.dispatchEvent(new CustomEvent("logoutUser"));
  }

  hide() {
    this.#hideModal();
  }

  // hide modal when clicking ESC
  closeWithKeyboard(event) {
    if (event.code == "Escape") {
      this.#hideModal();
    }
  }

  #showModal() {
    this.menuNavTarget.classList.add("opened");
    this.spMenuBtnTarget.classList.add("opened");
    document.body.style.overflow = "hidden";
  }

  #hideModal() {
    this.menuNavTarget.classList.remove("opened");
    this.spMenuBtnTarget.classList.remove("opened");
    document.body.style.overflow = "initial";
  }
}
