import UserStatusController from "controllers/user_status_controller";
import { FetchRequest } from "@rails/request.js";
import "slick-carousel-latest";

export default class extends UserStatusController {
  static targets = [
    "uploadForm",
    "errorBox",
    "uploadBox",
    "carousel",
    "imagePath",
    "inputFile",
  ];
  static values = {
    indexUrl: { type: String, default: "" },
    currPage: { type: Number, default: 0 },
    maxPage: { type: Number, default: 1 },
  };

  static outlets = ["user-status"];

  connect() {
    this.#loadCarousel();
    $(".carousel").on("edge", () => {
      window.dispatchEvent(new CustomEvent("loadImages"));
    });
    this.loadImages();
  }

  clearForm() {
    this.inputFileTarget.value = "";
  }

  userLoggedIn() {
    this.loadImages();
  }

  async loadImages() {
    if (
      this.userStatusOutlet.lengths == 0 ||
      !this.userStatusOutlet ||
      !this.userStatusOutlet.hasUsernameValue
    )
      return;
    if (!this.indexUrlValue) return;
    if (this.currPageValue >= this.maxPageValue) return;
    this.currPageValue += 1;
    const req = new FetchRequest(
      "GET",
      this.indexUrlValue + "?page=" + this.currPageValue,
      {
        responseKind: "turbo-stream",
      },
    );
    const response = await req.perform();

    if (response.ok) {
      const data = await response.json;
      this.currPageValue = data["pagy"]["page"];
      this.maxPageValue = data["pagy"]["last"];
      if (data["user_images"].length > 0) {
        this.#resetCarousel();
        data["user_images"].forEach((image) => {
          this.#appendImage(this.#newSwipeEl(image));
        });
        this.#loadCarousel();
      }
    }
  }

  requestUpload() {
    /*  stimulus target, inputFileLocalTarget, is unreliable
        which returns an empty file
    */
    const inputFileLocalTarget = document.getElementById("user_image_image");
    if (inputFileLocalTarget.files.length == 0) return this.clearForm();

    const uploadFormTarget = document.getElementById("userImageForm"); // stimulus file Target is slow
    fetch(uploadFormTarget.action, {
      method: uploadFormTarget.method,
      body: new FormData(uploadFormTarget),
    }).then((response) => {
      const ulTag = this.errorBoxTarget.getElementsByTagName("ul")[0];
      if (response.ok) {
        response.json().then((data) => {
          data.images.forEach((img) =>
            this.#prependImage(this.#newSwipeEl(img)),
          );
          if (data.errors > 0) {
            this.addErrMsgs(ulTag, data.errors);
            this.errorBoxTarget.classList.remove("hidden");
          }
        });
      } else {
        const errorStatus = response.status;
        const contentType = response.headers.get("content-type");
        if (contentType && contentType.indexOf("application/json") !== -1) {
          response.json().then((data) => {
            if (errorStatus == 422 || errorStatus == 403)
              this.addErrMsgs(ulTag, data);
            else this.addErrMsgs(ulTag, [data.message]);
            if (errorStatus === 403) this.dispatchLoginForm();
          });
        } else {
          response.text().then((text) => this.addErrMsgs(ulTag, [text]));
        }
        this.errorBoxTarget.classList.remove("hidden");
      }
      this.clearForm();
    });
  }

  selectImage(e) {
    let slideEl = e.target.closest(".image-slide");
    if (slideEl == null) return;
    e.preventDefault();
    this.imagePathTarget.value = slideEl.dataset.url;
  }

  #resetCarousel() {
    $(".carousel").slick("unslick");
  }

  #loadCarousel() {
    $(".carousel").slick({
      infinite: false,
      speed: 300,
      slidesToShow: 4,
      centerMode: true,
      variableWidth: true,
      arrows: true,
    });
  }

  #newSwipeEl(data) {
    var el = document.createElement("div");
    el.setAttribute("class", "swiper-slide image-slide");
    el.setAttribute("data-url", data["image_link"]);
    el.innerHTML = `<div class="gal-inner-holder">
      <div class="img"><img src="${data["thumbnail_link"]}" title="${data["filename"]}"></div>
      <div class="img-data">${data["filename"]}</div>
    </div>`;
    return el;
  }

  #appendImage(swipeEl) {
    this.carouselTarget.append(swipeEl);
  }

  #prependImage(swipeEl) {
    this.#resetCarousel();
    this.uploadBoxTarget.after(swipeEl);
    this.#loadCarousel();
    this.imagePathTarget.value = swipeEl.dataset.url;
  }
}
