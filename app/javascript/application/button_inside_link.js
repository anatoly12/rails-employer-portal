;(() => {
  const setup = () => {
    document.querySelectorAll('button').forEach((button) => {
      var link = button.closest('a')
      if (link) {
        link.originalHref = link.href
        button.addEventListener('mouseenter', removeHref, false)
        button.addEventListener('mouseleave', restoreHref, false)
      }
    })
  }
  const teardown = () => {
    document.querySelectorAll('button').forEach((button) => {
      var link = button.closest('a')
      if (link && link.originalHref) {
        link.setAttribute('href', link.originalHref)
        button.removeEventListener('mouseenter', removeHref, false)
        button.removeEventListener('mouseleave', restoreHref, false)
      }
    })
  }
  const removeHref = (e) => {
    const link = e.target.closest('a')
    link.removeAttribute('href')
  }
  const restoreHref = (e) => {
    const link = e.target.closest('a')
    link.setAttribute('href', link.originalHref)
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
