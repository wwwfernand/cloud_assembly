import BaseController from "controllers/base_controller";
import { FetchRequest } from "@rails/request.js";
import "slick-carousel-latest";

export default class extends BaseController {
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

  connect() {
    this.#loadCarousel();
    $(".carousel").on("edge", () => {
      window.dispatchEvent(new CustomEvent("loadImages"));
    });
    this.loadImages();
  }

  async loadImages() {
    if (!this.isLoggedIn()) return;
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
    if (!this.isLoggedIn()) {
      inputFileLocalTarget.value = "";
      return this.dispatchLoginModal();
    }
    if (inputFileLocalTarget.files.length == 0) {
      inputFileLocalTarget.value = "";
      return;
    }

    const uploadFormTarget = document.getElementById("userImageForm"); // stimulus file Target is slow
    fetch(uploadFormTarget.action, {
      method: uploadFormTarget.method,
      body: new FormData(uploadFormTarget),
    }).then((response) => {
      if (response.ok) {
        response.json().then((data) => {
          this.#prependImage(this.#newSwipeEl(data));
        });
      } else {
        let errorStatus = response.status;
        const ulTag = this.errorBoxTarget.getElementsByTagName("ul")[0];
        response.json().then((data) => {
          if (errorStatus == 422 || errorStatus == 403) {
            this.addErrMsgs(ulTag, data);
          } else {
            this.addErrMsgs(ulTag, [data.message]);
          }
          this.errorBoxTarget.classList.remove("hidden");
          if (errorStatus === 403) {
            this.dispatchLoginModal();
          }
        });
      }
      inputFileLocalTarget.value = "";
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
