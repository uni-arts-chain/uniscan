import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "tokens", "url", "loadMoreBtn" ]

  connect() {
  }

  loadMore() {
    // targets
    let tokensTarget = this.tokensTarget;
    let urlTarget = this.urlTarget;
    let loadMoreBtnTarget = this.loadMoreBtnTarget;

    // get url of next page
    let url = urlTarget.textContent;

    // request more tokens
    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    request.setRequestHeader('Accept', 'application/json');
    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var data = JSON.parse(this.response);
        if(!data.next_page_url) {
          loadMoreBtnTarget.parentNode.removeChild(loadMoreBtnTarget)
          urlTarget.parentNode.removeChild(urlTarget)
        } else {
          urlTarget.innerHTML= data.next_page_url;
        }
        tokensTarget.insertAdjacentHTML("beforeend", data.entries);
      }
    };
    request.send();
  }
}
