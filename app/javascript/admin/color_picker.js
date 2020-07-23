const Picker = require('vanilla-picker').default

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('input[data-color]').forEach((input) => {
    const parent = input.nextElementSibling
    const inside = parent.querySelector('div')
    new Picker({
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
})
