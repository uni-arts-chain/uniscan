import { Controller } from "@hotwired/stimulus"
import Glide from '@glidejs/glide'

function buildGlide(glideId) {
  var glide1Hidden = document.querySelector("#" + glideId + "-hidden");
  document.querySelector("#" + glideId).innerHTML = glide1Hidden.innerHTML;
  var glide1 = new Glide('#' + glideId, {
    type: 'carousel',
    perView: 8,
    focusAt: 0,
    gap: 28,
    // peek: 60,
    breakpoints: {
      1400: {
        perView: 6
      },
      800: {
        perView: 4
      },
      480: {
        perView: 2
      }
    }
  })

  glide1.mount()
}

export default class extends Controller {
  static targets = [ "glide1" ]

  connect() {
    buildGlide("glide1")
    buildGlide("glide2")
    buildGlide("glide3")
    buildGlide("glide4")
  }

  loadMore() {
  }
}
