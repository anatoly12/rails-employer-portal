document.addEventListener('turbolinks:before-visit', () => {
  document.querySelectorAll('button').forEach((button) => {
    var a = button.closest('a')
    if (a && a.originalHref) {
      a.classList.setAttribute('href', a.originalHref)
    }
  })
})
document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('button').forEach((button) => {
    var a = button.closest('a')
    if (a) {
      a.originalHref = a.href
      button.addEventListener('mouseenter', () => {
        a.removeAttribute('href')
      })
      button.addEventListener('mouseleave', () => {
        a.setAttribute('href', a.originalHref)
      })
    }
  })
})
