document.addEventListener('turbolinks:load', () => {
  const toggleLinkedTo = (select) => {
    document
      .querySelectorAll(`[data-linked-to-id='${select.id}']`)
      .forEach((div) => {
        if (select.value && div.dataset.linkedToValue == select.value) {
          div
            .querySelectorAll('input,select')
            .forEach((control) => control.removeAttribute('disabled'))
          div.classList.remove('hidden')
        } else {
          div.classList.add('hidden')
          div
            .querySelectorAll('input,select')
            .forEach((control) => control.setAttribute('disabled', 'disabled'))
        }
      })
  }
  document.querySelectorAll('select').forEach((select) => {
    select.addEventListener('change', () => toggleLinkedTo(select))
    toggleLinkedTo(select)
  })
})
