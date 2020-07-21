import Tagify from '@yaireo/tagify'

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('input[data-tagging]').forEach((input) => {
    const whitelist = input.dataset.whitelist || ''
    new Tagify(input, {
      whitelist: whitelist.split(','),
      dropdown: {
        maxItems: 3,
        enabled: 0,
        closeOnSelect: false,
      },
    })
  })
})
