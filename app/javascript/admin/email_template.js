require('codemirror/mode/htmlmixed/htmlmixed')
const CodeMirror = require('codemirror')

document.addEventListener('turbolinks:load', () => {
  // convert textarea to codemirror
  const textareas = document.querySelectorAll('textarea[data-codemirror]')
  if (textareas.length == 0) return
  textareas.forEach((textarea) => {
    CodeMirror.fromTextArea(textarea, {
      lineNumbers: true,
      mode: textarea.dataset.codemirror,
    })
  })

  const getCurrentCodeMirror = () => {
    var res
    textareas.forEach((textarea) => {
      var parent = textarea.parentNode
      if (!parent.classList.contains('hidden')) {
        res = parent.querySelector('.CodeMirror')
      }
    })
    return res
  }

  // toggle format
  var format = 'html'
  var preview = false
  const toggleFormatLinks = document.querySelectorAll('#toggle-format a')
  const togglePreviewLinks = document.querySelectorAll('#toggle-preview a')
  const htmlHelp = document.getElementById('html-help')
  const htmlPreview = document.getElementById('html-preview')
  const toggleContent = () => {
    textareas.forEach((textarea) => {
      var parent = textarea.parentNode
      var codemirror = parent.querySelector('.CodeMirror')
      if (!preview && textarea.id.endsWith(format)) {
        parent.classList.remove('hidden')
        codemirror.CodeMirror.refresh()
      } else {
        parent.classList.add('hidden')
      }
    })
    toggleFormatLinks.forEach((link) => {
      if (link.textContent.toLowerCase().trim() == format) {
        link.classList.remove('bg-gray-300')
        link.classList.add('bg-gray-500')
      } else {
        link.classList.remove('bg-gray-500')
        link.classList.add('bg-gray-300')
      }
    })
    togglePreviewLinks.forEach((link) => {
      var isPreview = link.textContent.toLowerCase().trim() == 'preview'
      if (isPreview == preview) {
        link.classList.remove('bg-gray-300')
        link.classList.add('bg-gray-500')
      } else {
        link.classList.remove('bg-gray-500')
        link.classList.add('bg-gray-300')
      }
    })
    if (format == 'html') {
      htmlHelp.classList.remove('hidden')
    } else {
      htmlHelp.classList.add('hidden')
    }
    if (preview) {
      textareas.forEach((textarea) => {
        if (textarea.id.endsWith('html')) {
          htmlPreview.innerHTML = textarea.parentNode
            .querySelector('.CodeMirror')
            .CodeMirror.getValue()
        }
      })
      htmlPreview.classList.remove('hidden')
    } else {
      htmlPreview.classList.add('hidden')
    }
  }
  toggleContent('html')
  toggleFormatLinks.forEach((link) => {
    link.addEventListener('mousedown', (event) => {
      event.preventDefault()
      format = link.textContent.toLowerCase().trim()
      preview = false
      toggleContent()
    })
  })
  togglePreviewLinks.forEach((link) => {
    link.addEventListener('mousedown', (event) => {
      event.preventDefault()
      preview = link.textContent.toLowerCase().trim() == 'preview'
      toggleContent()
    })
  })

  // insert merge tag on click
  document.querySelectorAll('li[data-insert]').forEach((link) => {
    link.addEventListener('click', () => {
      var codemirror = getCurrentCodeMirror()
      if (codemirror && !preview) {
        let doc = codemirror.CodeMirror.getDoc()
        let cursor = doc.getCursor()
        doc.replaceRange(link.dataset.insert, cursor)
        codemirror.querySelector('textarea').focus()
      }
    })
  })
})
