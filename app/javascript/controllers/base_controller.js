import { Controller } from "@hotwired/stimulus";

const DEVICE_PC = "pc";
const DEVICE_SP = "sp";

export default class extends Controller {
  dispatchLoginForm() {
    window.dispatchEvent(new CustomEvent("showLoginForm"));
    window.dispatchEvent(new CustomEvent("clearForm"));
  }

  scrollToTop() {
    window.scrollTo({ top: 0, behavior: "smooth" });
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
    if (str) return str.match(/^ *$/) !== null;
    return true;
  }

  targetDevice() {
    if ($(window).width() > 992) return DEVICE_PC;
    return DEVICE_SP;
  }
}
