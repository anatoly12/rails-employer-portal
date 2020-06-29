document.addEventListener('turbolinks:load', () => {
  // automatically close success messages after 3 seconds
  setTimeout(() => {
    document.querySelectorAll('[role=notice]').forEach((notice) => {
      notice.classList.add('opacity-0')
    })
  }, 3000)

  // allow to manually close all flash messages on click
  document.querySelectorAll('[role=alert], [role=notice]').forEach((alert) => {
    alert.addEventListener('click', () => alert.classList.add('opacity-0'))
  })
})
