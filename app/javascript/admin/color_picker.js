const Picker = require('vanilla-picker').default

;(() => {
  const setup = () => {
    document.querySelectorAll('input[data-color]').forEach((input) => {
      const parent = input.nextElementSibling
      const inside = parent.querySelector('div')
      input.picker = new Picker({
        parent,
        color: input.value,
        alpha: false,
        onChange: (color) => {
          const hex = color.hex.substring(0, 7) // remove alpha
          inside.style.background = hex
          input.value = hex
        },
      })
    })
  }
  const teardown = () => {
    document.querySelectorAll('input[data-color]').forEach((input) => {
      if (input.picker) input.picker.destroy()
    })
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
