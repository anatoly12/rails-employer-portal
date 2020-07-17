
import Tagify from '@yaireo/tagify'

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('input[data-tagging]').forEach((input) => {
    const whitelist = input.dataset.whitelist || "";
    new Tagify(input, {
      whitelist: whitelist.split(","),
      dropdown: {
        maxItems: 20,
        enabled: 1,
        closeOnSelect: true
      }
    });
  })
})
