;(() => {
  const setup = () => {
    document.querySelectorAll('form[method=get]').forEach((form) => {
      form.addEventListener('submit', onSubmit, false)
    })
  }
  const teardown = () => {
    document.querySelectorAll('form[method=get]').forEach((form) => {
      form.removeEventListener('submit', onSubmit, false)
    })
  }
  const onSubmit = (e) => {
    e.preventDefault()
    const form = e.target
    if (form.dataset.persistScroll) {
      window.scrollPosition = window.scrollY
    }
    Turbolinks.visit(
      `${form.action}?${new URLSearchParams(new FormData(form))}`
    )
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
