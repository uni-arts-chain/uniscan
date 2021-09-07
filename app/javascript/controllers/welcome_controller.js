import { Controller } from "@hotwired/stimulus"

import $ from "jquery"
import jQueryBridget from 'jquery-bridget';

import Masonry from 'masonry-layout';

// import ImagesLoaded from "imagesloaded"

export default class extends Controller {
  connect() {

    jQueryBridget( 'masonry', Masonry, $ );
    // jQueryBridget( 'imagesLoaded', ImagesLoaded, $ );

    // var $grid = $('.items').imagesLoaded( function() {
    //   $grid.masonry({
    //     itemSelector: ".item",
    //     percentPosition: true
    //   });
    // });

    $(".item img").on("load", function() {
      $(".items").masonry({
        itemSelector: ".item",
        percentPosition: true
      });
    })

  }
}
