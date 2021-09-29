import { Controller } from "@hotwired/stimulus"
import Glide from '@glidejs/glide'

function buildGlide(glideId) {
  var glide1Hidden = document.querySelector("#" + glideId + "-hidden");
  document.querySelector("#" + glideId).innerHTML = glide1Hidden.innerHTML;
  var glide1 = new Glide('#' + glideId, {
    type: 'carousel',
    perView: 6,
    focusAt: 0,
    gap: 28,
    // peek: 60,
    breakpoints: {
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
    // var glide2 = new Glide('#glide2', {
    //   type: 'carousel',
    //   perView: 6,
    //   peek: 60,
    //   breakpoints: {
    //     800: {
    //       perView: 4
    //     },
    //     480: {
    //       perView: 2
    //     }
    //   }
    // })

    // glide2.mount()

    // var glide3 = new Glide('#glide3', {
    //   type: 'carousel',
    //   perView: 6,
    //   peek: 60,
    //   breakpoints: {
    //     800: {
    //       perView: 4
    //     },
    //     480: {
    //       perView: 2
    //     }
    //   }
    // })

    // glide3.mount()

    // var glide4 = new Glide('#glide4', {
    //   type: 'carousel',
    //   perView: 6,
    //   peek: 60,
    //   breakpoints: {
    //     800: {
    //       perView: 4
    //     },
    //     480: {
    //       perView: 2
    //     }
    //   }
    // })

    // glide4.mount()
  }

  loadMore() {
  }
}
