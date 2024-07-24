import BaseController from "controllers/base_controller";

export default class extends BaseController {
  showForm(event) {
    if (event) event.preventDefault();
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
    if (!event.target.closest(".modal-container")) {
      console.log("inside background");
      this.#hideModal();
    }
  }

  broadcastUserLoggedIn(data) {
    this.hideForm();
    this.showUserMenu();
    window.dispatchEvent(
      new CustomEvent("userLoggedIn", {
        detail: { username: data["username"] },
        cancelable: false,
      }),
    );
  }

  /*
  // hide modal when other modal displayed
  hideModals(event){
    this.#hideModal(false);
  }*/

  #hideModal(resetBody = true) {
    if (resetBody) document.body.style.overflow = "initial";
    this.isopenValue = false;
    this.formModalTarget.classList.add("hidden");
    this.formModalTarget.classList.remove("is-open");
  }
}
