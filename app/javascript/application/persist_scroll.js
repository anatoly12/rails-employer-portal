history.scrollRestoration = 'manual'
let scrollPosition = null
document.addEventListener('turbolinks:render', () => {
  if (scrollPosition != null) {
    window.scrollTo({ left: 0, top: scrollPosition, behavior: 'auto' })
    scrollPosition = null
  }
})
document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('[data-persist-scroll]').forEach((link) => {
    link.addEventListener('click', () => {
      document.addEventListener(
        'turbolinks:before-render',
        () => {
          scrollPosition = window.scrollY
        },
        { once: true }
      )
    })
  })
})
