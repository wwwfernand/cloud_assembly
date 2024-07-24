import { Controller } from "@hotwired/stimulus";

const DEVICE_PC = "pc";
const DEVICE_SP = "sp";

export default class extends Controller {
  dispatchLoginForm() {
    window.dispatchEvent(new CustomEvent("showLoginForm"));
  }

  scrollToTop() {
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  isLoggedIn() {
    return !this.isEmptyOrSpaces(
      this.#userProfileTag().dataset.userSessionsUsernameValue,
    );
  }

  setCurrentUser(event) {
    if (!this.isLoggedIn()) {
      event.stopImmediatePropagation();
      dispatchLoginForm();
    }
  }

  addErrMsgs(ulTag, body) {
    ulTag.innerHTML = "";
    if (Array.isArray(body)) {
      body.forEach((msg) => {
        let li = document.createElement("li");
        ulTag.appendChild(li);
        li.innerText = msg;
      });
    } else {
      for (const [key, errors] of Object.entries(body)) {
        errors.forEach((error) => {
          let li = document.createElement("li");
          ulTag.appendChild(li);
          if (key === "base") li.innerText = error;
          else li.innerText = `${key} ${error}`;
        });
      }
    }
  }

  isEmptyOrSpaces(str) {
    return str === null || str.match(/^ *$/) !== null;
  }

  showUserMenu() {
    document.querySelectorAll(".login-zumi").forEach((el) => {
      el.classList.remove("hidden");
    });
    document.querySelectorAll(".mi-login").forEach((el) => {
      el.classList.add("hidden");
    });
    let targetDevice = this.#targetDevice();
    document.querySelectorAll(".login-zumi-" + targetDevice).forEach((el) => {
      el.classList.remove("hidden");
    });
    document.querySelectorAll(".mi-login-" + targetDevice).forEach((el) => {
      el.classList.add("hidden");
    });
  }

  #targetDevice() {
    if ($(window).width() > 992) return DEVICE_PC;
    return DEVICE_SP;
  }

  #userProfileTag() {
    return document.getElementById("loginForm");
  }
}
