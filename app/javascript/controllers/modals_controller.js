import BaseController from "controllers/base_controller";

export default class extends BaseController {
  showForm(event) {
    if (event) event.preventDefault();
    this.scrollToTop();
    document.body.style.overflow = "hidden";
    this.formModalTarget.classList.remove("hidden");
    this.formModalTarget.classList.add("is-open");
    // delay flag timeout to prevent sudden dialog close
    setTimeout(() => {
      this.isopenValue = true;
    }, "60");
  }

  hideForm() {
    this.#hideModal();
  }

  // hide modal when clicking ESC
  closeWithKeyboard(event) {
    if (event.code == "Escape") this.#hideModal();
  }

  // hide modal when clicking outside of modal
  closeBackground(event) {
    if (!this.isopenValue) return;
    if (!event.target.closest(".modal-container")) this.#hideModal();
  }

  broadcastUserLoggedIn(data) {
    this.hideForm();
    window.dispatchEvent(
      new CustomEvent("userLoggedIn", {
        detail: { username: data["username"] },
        cancelable: false,
      }),
    );
  }

  #hideModal() {
    document.body.style.overflow = "initial";
    this.isopenValue = false;
    this.formModalTarget.classList.add("hidden");
    this.formModalTarget.classList.remove("is-open");
  }
}
