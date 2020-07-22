document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('[data-auto-submit]').forEach((input) => {
    input.addEventListener('change', () => {
      // prevent double-click
      input.parentNode.classList.add('pointer-events-none')
      // autosubmit
      input.form.submit()
    })
  })
})
