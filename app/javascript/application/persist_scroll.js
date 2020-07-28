;(() => {
  const setup = () => {
    document.querySelectorAll('[data-persist-scroll]').forEach((link) => {
      link.addEventListener('click', onClick, false)
    })
  }
  const teardown = () => {
    document.querySelectorAll('[data-persist-scroll]').forEach((link) => {
      link.removeEventListener('click', onClick, false)
    })
  }
  const render = () => {
    if (window.scrollPosition != null) {
      window.scrollTo({ left: 0, top: scrollPosition, behavior: 'auto' })
      window.scrollPosition = null
    }
  }
  const onClick = (e) => {
    document.addEventListener(
      'turbolinks:before-render',
      () => {
        window.scrollPosition = window.scrollY
      },
      { once: true }
    )
  }
  history.scrollRestoration = 'manual'
  window.scrollPosition = null
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
  document.addEventListener('turbolinks:render', render)
})()
