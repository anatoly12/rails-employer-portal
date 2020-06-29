const EasyPieChart = require('easy-pie-chart')

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('.chart').forEach((chart) => {
    if (chart.easyPieChart) {
      // chart already on the page, update its value
      chart.easyPieChart.update(chart.dataset.percent)
    } else {
      // play chart animation
      let color = chart.dataset.color
      chart.easyPieChart = new EasyPieChart(chart, {
        easing: 'easeOutElastic',
        delay: 3000,
        barColor: color,
        trackColor: color,
        scaleColor: false,
        size: 64,
        lineWidth: 6,
        trackWidth: 1.5,
        lineCap: 'butt',
        onStep: (_from, _to, percent) => {
          chart.children[0].innerHTML = `${Math.round(percent)}%`
        },
      })
    }
  })
})
