;(() => {
  const setup = () => {
    // automatically close success messages after 3 seconds
    setTimeout(() => {
      document
        .querySelectorAll('[role=notice]')
        .forEach((notice) => close(notice))
    }, 3000)

    // allow to manually close all flash messages on click
    document
      .querySelectorAll('[role=alert], [role=notice]')
      .forEach((message) => {
        message.addEventListener('click', () => close(message))
      })
  }
  const teardown = () => {
    // remove flash messages from cache
    document
      .querySelectorAll('[role=alert], [role=notice]')
      .forEach((message) => {
        message.parentNode.removeChild(message)
      })
  }
  const close = (message) => {
    message.classList.add('opacity-0')
    setTimeout(() => message.parentNode.removeChild(message), 700)
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
