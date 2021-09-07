# Use Action Cable channels (remember to import "@rails/actionable" in your application.js)
# pin "@rails/actioncable", to: "actioncable.esm.js"
# pin_all_from "app/javascript/channels", under: "channels"

# Use direct uploads for Active Storage (remember to import "@rails/activestorage" in your application.js)
# pin "@rails/activestorage", to: "activestorage.esm.js"

# Use node modules from a JavaScript CDN by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-importmap-autoloader", to: "stimulus-importmap-autoloader.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.js"

pin "jquery-bridget", to: "https://ga.jspm.io/npm:jquery-bridget@3.0.0/jquery-bridget.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js"

pin "imagesloaded", to: "https://cdn.skypack.dev/imagesloaded"

pin "masonry", to: "https://ga.jspm.io/npm:masonry@0.0.2/index.js"
pin "ejs", to: "https://ga.jspm.io/npm:ejs@0.7.1/lib/ejs.js"
pin "fs", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.10/nodelibs/browser/fs.js"
pin "masonry-layout", to: "https://ga.jspm.io/npm:masonry-layout@4.2.2/masonry.js"
pin "desandro-matches-selector", to: "https://ga.jspm.io/npm:desandro-matches-selector@2.0.2/matches-selector.js"
pin "ev-emitter", to: "https://ga.jspm.io/npm:ev-emitter@1.1.1/ev-emitter.js"
pin "fizzy-ui-utils", to: "https://ga.jspm.io/npm:fizzy-ui-utils@2.0.7/utils.js"
pin "get-size", to: "https://ga.jspm.io/npm:get-size@2.0.3/get-size.js"
pin "outlayer", to: "https://ga.jspm.io/npm:outlayer@2.1.1/outlayer.js"
