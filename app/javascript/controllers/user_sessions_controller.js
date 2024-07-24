import ModalsController from "controllers/modals_controller";

export default class extends ModalsController {
  static targets = ["errorBox", "formModal"];
  static values = {
    username: String,
    isopen: { type: Boolean, default: false },
  };

  connect() {
    if (window.location.pathname === "/new") this.showLoginForm();
  }

  showLoginForm(event) {
    if (this.isEmptyOrSpaces(this.usernameValue)) {
      if (event) event.stopImmediatePropagation();
      this.scrollToTop();
      this.showForm(event);
    }
  }

  switchSignUpForm(event) {
    this.hideForm();
    window.dispatchEvent(new CustomEvent("showSignUpForm"));
  }

  login(event) {
    event.preventDefault();
    fetch(event.target.action, {
      method: "POST",
      body: new FormData(event.target),
    }).then((response) => {
      if (response.ok) {
        response.json().then((data) => this.broadcastUserLoggedIn(data));
      } else {
        response.json().then((data) => {
          const ulTag = this.errorBoxTarget.getElementsByTagName("ul")[0];
          this.addErrMsgs(ulTag, data);
          this.errorBoxTarget.classList.remove("hidden");
        });
      }
    });
  }

  logout(event) {
    event.preventDefault();
    let confirmed = confirm("Do you wish to logout?");
    if (!confirmed) return;
    fetch("/logout.json", {
      method: "DELETE",
    }).then(() => (window.location.href = "/"));
  }
}
