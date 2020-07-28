require('codemirror/mode/htmlmixed/htmlmixed')
const CodeMirror = require('codemirror')

;(() => {
  var textareas = []
  var format = 'html'
  var preview = false

  const setup = () => {
    // convert textarea to codemirror
    textareas = document.querySelectorAll('textarea[data-codemirror]')
    if (textareas.length == 0) return
    textareas.forEach((textarea) => {
      CodeMirror.fromTextArea(textarea, {
        lineNumbers: true,
        mode: textarea.dataset.codemirror,
      })
    })
    toggleContent(format)
    document.querySelectorAll('#toggle-format a').forEach((link) => {
      link.addEventListener('mousedown', onFormatMouseDown, false)
    })
    document.querySelectorAll('#toggle-preview a').forEach((link) => {
      link.addEventListener('mousedown', onPreviewMouseDown, false)
    })
    document.querySelectorAll('li[data-insert]').forEach((link) => {
      link.addEventListener('click', onMergeTagClick, false)
    })
  }
  const teardown = () => {
    document.querySelectorAll('#toggle-format a').forEach((link) => {
      link.removeEventListener('mousedown', onFormatMouseDown, false)
    })
    document.querySelectorAll('#toggle-preview a').forEach((link) => {
      link.removeEventListener('mousedown', onPreviewMouseDown, false)
    })
    document.querySelectorAll('li[data-insert]').forEach((link) => {
      link.removeEventListener('click', onMergeTagClick, false)
    })
  }
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
    document.querySelectorAll('#toggle-format a').forEach((link) => {
      if (link.textContent.toLowerCase().trim() == format) {
        link.classList.remove('bg-gray-300')
        link.classList.add('bg-gray-500')
      } else {
        link.classList.remove('bg-gray-500')
        link.classList.add('bg-gray-300')
      }
    })
    document.querySelectorAll('#toggle-preview a').forEach((link) => {
      var isPreview = link.textContent.toLowerCase().trim() == 'preview'
      if (isPreview == preview) {
        link.classList.remove('bg-gray-300')
        link.classList.add('bg-gray-500')
      } else {
        link.classList.remove('bg-gray-500')
        link.classList.add('bg-gray-300')
      }
    })
    const htmlHelp = document.getElementById('html-help')
    if (format == 'html') {
      htmlHelp.classList.remove('hidden')
    } else {
      htmlHelp.classList.add('hidden')
    }
    const htmlPreview = document.getElementById('html-preview')
    if (preview) {
      textareas.forEach((textarea) => {
        if (textarea.id.endsWith('html')) {
          htmlPreview.srcdoc = textarea.parentNode
            .querySelector('.CodeMirror')
            .CodeMirror.getValue()
        }
      })
      htmlPreview.classList.remove('hidden')
    } else {
      htmlPreview.classList.add('hidden')
    }
  }
  const onFormatMouseDown = (event) => {
    event.preventDefault()
    const link = event.target
    format = link.textContent.toLowerCase().trim()
    preview = false
    toggleContent()
  }
  const onPreviewMouseDown = (event) => {
    event.preventDefault()
    const link = event.target
    preview = link.textContent.toLowerCase().trim() == 'preview'
    toggleContent()
  }
  const onMergeTagClick = (event) => {
    event.preventDefault()
    var codemirror = getCurrentCodeMirror()
    if (codemirror && !preview) {
      let doc = codemirror.CodeMirror.getDoc()
      let cursor = doc.getCursor()
      doc.replaceRange(link.dataset.insert, cursor)
      codemirror.querySelector('textarea').focus()
    }
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
