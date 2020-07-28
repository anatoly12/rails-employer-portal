;(() => {
  const setup = () => {
    document.querySelectorAll('.cursor-pointer[type=file]').forEach((input) => {
      input.setAttribute('title', '') // remove "No file chosen" tooltip from input[file]
      input.addEventListener('change', onChange, false)
    })
  }
  const teardown = () => {
    document.querySelectorAll('.cursor-pointer[type=file]').forEach((input) => {
      input.removeEventListener('change', onChange, false)
    })
  }
  const onChange = (e) => {
    const input = e.target
    const svg = input.parentNode.querySelector('svg') // show spinner
    if (svg) {
      const spinner = document.createElement('span')
      spinner.classList.add('spinner', ...svg.classList)
      svg.replaceWith(spinner)
    }
    input.parentNode.classList.add('pointer-events-none') // prevent double-click
    input.form.submit() // autosubmit
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
