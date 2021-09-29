import { Controller } from "@hotwired/stimulus"
import LazyLoad from 'lazyload'

export default class extends Controller {
  static targets = []

  connect() {
    let images = document.querySelectorAll(".nft-img");
    new LazyLoad(images);
  }

}
