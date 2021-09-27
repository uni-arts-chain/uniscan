import { Controller } from "@hotwired/stimulus"
import Glide from '@glidejs/glide'
import jQuery from 'jquery';
import 'slick-carousel'

export default class extends Controller {
  static targets = [ "newNfts" ]

  connect() {
    jQuery('.my-slick').slick({
      infinite: false,
      lazyLoad: 'ondemand',
      slidesToShow: 6,
      slidesToScroll: 2,
      swipeToSlide: true
    });

    const bodyWidth = jQuery(document).width();
    const oriWidth = jQuery(".my-slick").width();
    const newWidth = oriWidth + (bodyWidth - oriWidth) / 2;
    jQuery(".my-slick").width(newWidth);
    jQuery(".slick-prev").css({left: newWidth - 60})
    jQuery(".slick-next").css({left: newWidth - 35})
    // var glide1 = new Glide('#glide1', {
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

    // glide1.mount()

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
