document.addEventListener('turbolinks:load', () => {
  var tooltip
  const tooltipCleanup = () => {
    if (tooltip) {
      tooltip.parentNode.removeChild(tooltip)
      tooltip = null
    }
  }
  const tooltipSetup = (link) => {
    tooltip = document.createElement('div')
    tooltip.className = 'absolute pointer-events-none'
    tooltip.innerHTML = `
      <div class="absolute bottom-0 -ml-2 pb-3 z-90">
        <div class="w-32 bg-black text-white text-xs rounded p-2 right-0 bottom-full shadow">
          ${link.dataset.tooltip}
          <div class="absolute ml-5 mb-1 left-0 bottom-0 border-black border-8 border-b-0" style="border-left-color:transparent;border-right-color:transparent"></div>
        </div>
      </div>
    `
    tooltip.offsetLeft = link.offsetLeft
    tooltip.offsetTop = link.offsetTop
    link.parentNode.appendChild(tooltip)
  }
  document.querySelectorAll('a[title]').forEach((link) => {
    var title = link.getAttribute('title')
    link.title = ''
    link.dataset.tooltip = title
    link.addEventListener('mouseenter', () => {
      tooltipCleanup()
      tooltipSetup(link)
    })
    link.addEventListener('mouseleave', () => {
      tooltipCleanup()
    })
  })
})
