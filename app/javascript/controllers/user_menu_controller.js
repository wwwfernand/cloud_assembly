import BaseController from "controllers/base_controller";

export default class extends BaseController {
  static targets = ["menuNav", "spMenuBtn"];

  toggle() {
    if (this.spMenuBtnTarget.classList.contains("opened")) this.hide();
    else this.#showModal();
  }

  switchLoginForm() {
    this.hide();
    this.dispatchLoginForm();
  }

  dispatchLogoutUser() {
    window.dispatchEvent(new CustomEvent("logoutUser"));
  }

  hide() {
    this.menuNavTarget.classList.remove("opened");
    this.spMenuBtnTarget.classList.remove("opened");
    document.body.style.overflow = "initial";
  }

  // hide modal when clicking ESC
  closeWithKeyboard(event) {
    if (event.code == "Escape") this.hide();
  }

  #showModal() {
    this.menuNavTarget.classList.add("opened");
    this.spMenuBtnTarget.classList.add("opened");
    document.body.style.overflow = "hidden";
  }
}
