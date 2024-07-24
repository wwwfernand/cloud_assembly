import ModalsController from "controllers/modals_controller";

export default class extends ModalsController {
  static targets = ["errorBox", "formModal"];
  static values = {
    isopen: { type: Boolean, default: false },
  };

  switchLoginForm(event) {
    this.hideForm();
    this.dispatchLoginForm();
  }

  submit(event) {
    event.preventDefault();
    fetch(event.target.action, {
      method: "POST",
      body: new FormData(event.target),
    }).then((response) => {
      if (response.ok) {
        response.json().then((data) => this.broadcastUserLoggedIn(data));
      } else {
        response.json().then((data) => {
          let ulTag = this.errorBoxTarget.getElementsByTagName("ul")[0];
          this.addErrMsgs(ulTag, data);
          this.errorBoxTarget.classList.remove("hidden");
        });
      }
    });
  }
}
