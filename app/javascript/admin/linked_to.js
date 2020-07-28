;(() => {
  const setup = () => {
    document.querySelectorAll('select').forEach((select) => {
      select.addEventListener('change', onChange, false)
      toggleLinkedTo(select)
    })
  }
  const teardown = () => {
    document.querySelectorAll('select').forEach((select) => {
      select.removeEventListener('change', onChange, false)
    })
  }
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
  const onChange = (e) => {
    const select = e.target
    toggleLinkedTo(select)
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
