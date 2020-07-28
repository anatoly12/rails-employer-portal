import Tagify from '@yaireo/tagify'
;(() => {
  const setup = () => {
    document.querySelectorAll('input[data-tagging]').forEach((input) => {
      const whitelist = (input.dataset.whitelist || '')
        .split(',')
        .filter((s) => s != '')
      const enforceWhitelist = input.dataset.enforceWhitelist != 'false'
      input.tagify = new Tagify(input, {
        whitelist,
        enforceWhitelist,
        dropdown: {
          maxItems: 3,
          enabled: whitelist.length > 0 ? 0 : 1,
          closeOnSelect: false,
        },
        originalInputValueFormat: (valuesArr) =>
          valuesArr.map((item) => item.value).join(','),
      })
    })
  }
  const teardown = () => {
    document.querySelectorAll('input[data-tagging]').forEach((input) => {
      if (input.tagify) input.tagify.destroy()
    })
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
