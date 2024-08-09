import BaseController from "controllers/base_controller";

export default class extends BaseController {
  static values = { username: String };

  requireLogin(event) {
    if (!this.hasUsernameValue) {
      event.stopImmediatePropagation();
      event.preventDefault();
      this.dispatchLoginForm();
    }
  }

  userLoggedIn(event) {
    this.usernameValue = event.detail.username;
    document.querySelectorAll(".login-zumi").forEach((el) => {
      el.classList.remove("hidden");
    });
    document.querySelectorAll(".mi-login").forEach((el) => {
      el.classList.add("hidden");
    });
    let targetDevice = this.targetDevice();
    document.querySelectorAll(".login-zumi-" + targetDevice).forEach((el) => {
      el.classList.remove("hidden");
    });
    document.querySelectorAll(".mi-login-" + targetDevice).forEach((el) => {
      el.classList.add("hidden");
    });
  }
}
