# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js" # @3.7.1
pin "@tailwindcss/forms", to: "@tailwindcss--forms.js" # @0.5.7
pin "tailwindcss/colors", to: "tailwindcss--colors.js" # @3.4.4
pin "tailwindcss/defaultTheme", to: "tailwindcss--defaultTheme.js" # @3.4.4
pin "tailwindcss/plugin", to: "tailwindcss--plugin.js" # @3.4.4
pin "ckeditor5", to: "https://cdn.ckeditor.com/ckeditor5/42.0.0/ckeditor5.js"
pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@2.4.1/dist/flowbite.turbo.min.js"
pin "flowbite-datepicker", to: "https://cdn.jsdelivr.net/npm/flowbite@2.3.0/dist/datepicker.turbo.min.js"
pin "@stimulus-components/clipboard", to: "@stimulus-components--clipboard.js" # @5.0.0
pin "slick-carousel-latest" # @1.9.0
