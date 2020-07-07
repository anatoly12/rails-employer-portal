document.addEventListener('turbolinks:load', () => {
  const close = (message) => {
    message.classList.add('opacity-0')
    setTimeout(() => message.parentNode.removeChild(message), 700)
  }

  // automatically close success messages after 3 seconds
  setTimeout(() => {
    document
      .querySelectorAll('[role=notice]')
      .forEach((notice) => close(notice))
  }, 3000)

  // allow to manually close all flash messages on click
  document.querySelectorAll('[role=alert], [role=notice]').forEach((alert) => {
    alert.addEventListener('click', () => close(alert))
  })
})
