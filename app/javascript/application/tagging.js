import Tagify from '@yaireo/tagify'

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('input[data-tagging]').forEach((input) => {
    const whitelist = input.dataset.whitelist || ''
    new Tagify(input, {
      whitelist: whitelist.split(','),
      dropdown: {
        maxItems: 3,
        enabled: whitelist.length > 0 ? 0 : 1,
        closeOnSelect: false,
      },
    })
  })
})
