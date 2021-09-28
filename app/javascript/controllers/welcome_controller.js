import { Controller } from "@hotwired/stimulus"
import Glide from '@glidejs/glide'
import jQuery from 'jquery';
import 'slick-carousel'

function initSlick() {
  jQuery('.my-slick').slick({
    infinite: false,
    lazyLoad: 'ondemand',
    slidesToShow: 10,
    slidesToScroll: 3,
    swipeToSlide: true,
    responsive: [
      {
        breakpoint: 1600,
        settings: {
          slidesToShow: 8,
          slidesToScroll: 3,
        }
      },
      {
        breakpoint: 1400,
        settings: {
          slidesToShow: 6,
          slidesToScroll: 3,
        }
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 4,
          slidesToScroll: 2,
        }
      },
      {
        breakpoint: 800,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 1,
        }
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 1
        }
      }
    ]
  });

  // const mySlickWidth = jQuery(".my-slick").width();
  // jQuery(".slick-prev").css({right: 40})
  // jQuery(".slick-next").css({right: 20})

}

export default class extends Controller {
  static targets = [ "newNfts" ]

  connect() {
    initSlick()
    // $('.my-slick').on('breakpoint', function(event, slick, breakpoint){
    //   jQuery(".slick-prev").css({right: 40})
    //   jQuery(".slick-next").css({right: 20})
    // });
    // jQuery('window').resize(function() {
    //   jQuery(".slick-prev").css({right: 40})
    //   jQuery(".slick-next").css({right: 20})
    // });
  }

}


