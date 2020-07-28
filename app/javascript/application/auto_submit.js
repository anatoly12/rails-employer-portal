;(() => {
  const setup = () => {
    document.querySelectorAll('[data-auto-submit]').forEach((input) => {
      input.addEventListener('keydown', onKeyDown, false)
      input.addEventListener('keyup', onKeyUp, false)
      input.addEventListener('focus', onFocus, false)
      input.addEventListener('change', onChange, false)
      input.addEventListener('blur', onBlur, false)
      input.addEventListener('keypress', onKeyPress, false)
    })
  }
  const teardown = () => {
    document.querySelectorAll('[data-auto-submit]').forEach((input) => {
      input.removeEventListener('keydown', onKeyDown, false)
      input.removeEventListener('keyup', onKeyUp, false)
      input.removeEventListener('focus', onFocus, false)
      input.removeEventListener('change', onChange, false)
      input.removeEventListener('blur', onBlur, false)
      input.removeEventListener('keypress', onKeyPress, false)
    })
  }
  const submit = (input) => {
    input.parentNode.classList.add('pointer-events-none') // prevent double-click
    input.form.dispatchEvent(new Event('submit')) // autosubmit
  }
  const onKeyDown = (e) => {
    e.target.typing = true
  }
  const onKeyUp = (e) => {
    e.target.typing = false
  }
  const onFocus = (e) => {
    const input = e.target
    input.previousValue = input.value
  }
  const onChange = (e) => {
    const input = e.target
    if (!input.typing) submit(input)
  }
  const onBlur = (e) => {
    const input = e.target
    if (input.previousValue != input.value) submit(input)
  }
  const onKeyPress = (e) => {
    if (e.keyCode === 13) {
      e.preventDefault()
      e.target.blur()
    }
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
