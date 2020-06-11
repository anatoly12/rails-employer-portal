var EasyPieChart = require('easy-pie-chart')

document.addEventListener('DOMContentLoaded', () => {
  setTimeout(() => {
    document.querySelectorAll('[role=notice]').forEach((notice) => {
      alert.classList.add("opacity-0");
    });
  }, 3000);
  document.querySelectorAll('[role=alert], [role=notice]').forEach((alert) => {
    alert.addEventListener('click', () => alert.classList.add("opacity-0"));
  });

  document.querySelectorAll('.chart').forEach((chart) => {
    let color = chart.dataset.color
    new EasyPieChart(chart, {
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
  })
})
