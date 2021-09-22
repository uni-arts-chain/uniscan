import { Controller } from "@hotwired/stimulus"
import Glide from '@glidejs/glide'

export default class extends Controller {
  static targets = [ "newNfts" ]

  connect() {
    var glide1 = new Glide('#glide1', {
      type: 'carousel',
      perView: 6,
      peek: 60,
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

    var glide2 = new Glide('#glide2', {
      type: 'carousel',
      perView: 6,
      peek: 60,
      breakpoints: {
        800: {
          perView: 4
        },
        480: {
          perView: 2
        }
      }
    })

    glide2.mount()

    var glide3 = new Glide('#glide3', {
      type: 'carousel',
      perView: 6,
      peek: 60,
      breakpoints: {
        800: {
          perView: 4
        },
        480: {
          perView: 2
        }
      }
    })

    glide3.mount()

    var glide4 = new Glide('#glide4', {
      type: 'carousel',
      perView: 6,
      peek: 60,
      breakpoints: {
        800: {
          perView: 4
        },
        480: {
          perView: 2
        }
      }
    })

    glide4.mount()
  }

  loadMore() {
  }
}
