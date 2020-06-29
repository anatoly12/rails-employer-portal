document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('.cursor-pointer[type=file]').forEach((input) => {
    // remove "No file chosen" tooltip from input[file]
    input.setAttribute('title', '')
    input.addEventListener('change', () => {
      // show spinner
      const svg = input.parentNode.querySelector('svg')
      if (svg) {
        const spinner = document.createElement('span')
        spinner.classList.add('spinner', ...svg.classList)
        svg.replaceWith(spinner)
      }
      // prevent double-click
      input.parentNode.classList.add('pointer-events-none')
      // autosubmit
      input.form.submit()
    })
  })
})
