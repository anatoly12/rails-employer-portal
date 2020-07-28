;(() => {
  var tooltip
  const setup = () => {
    document.querySelectorAll('a[title]').forEach((link) => {
      var title = link.getAttribute('title')
      link.title = ''
      link.dataset.tooltip = title
      link.addEventListener('mouseenter', onMouseEnter, false)
      link.addEventListener('mouseleave', onMouseLeave, false)
    })
  }
  const teardown = () => {
    tooltipCleanup()
    document.querySelectorAll('a').forEach((link) => {
      if (link.dataset.tooltip) {
        link.title = link.dataset.tooltip
        link.dataset.tooltip = null
        link.removeEventListener('mouseenter', onMouseEnter, false)
        link.removeEventListener('mouseleave', onMouseLeave, false)
      }
    })
  }
  const onMouseEnter = (e) => {
    tooltipCleanup()
    tooltipSetup(e.target)
  }
  const onMouseLeave = (_) => {
    tooltipCleanup()
  }
  const tooltipSetup = (link) => {
    tooltip = document.createElement('div')
    tooltip.className = 'absolute pointer-events-none'
    tooltip.innerHTML = `
      <div class="absolute bottom-0 pb-2 z-90">
        <div class="w-48 bg-gray-800 text-white text-xs font-medium rounded p-2 right-0 bottom-full shadow-xl">
          ${link.dataset.tooltip}
          <div class="absolute ml-3 left-0 bottom-0 border-gray-800 border-8 border-b-0" style="border-left-color:transparent;border-right-color:transparent"></div>
        </div>
      </div>
    `
    tooltip.style.left = `${link.offsetLeft - 18 + link.offsetWidth / 2}px`
    tooltip.style.top = `${link.offsetTop - 4}px`
    link.parentNode.appendChild(tooltip)
  }
  const tooltipCleanup = () => {
    if (tooltip) {
      tooltip.parentNode.removeChild(tooltip)
      tooltip = null
    }
  }
  document.addEventListener('turbolinks:load', setup)
  document.addEventListener('turbolinks:before-cache', teardown)
})()
