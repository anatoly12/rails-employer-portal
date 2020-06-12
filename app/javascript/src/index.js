const EasyPieChart = require('easy-pie-chart')

document.addEventListener('turbolinks:load', () => {
  // allow closing flash messages
  setTimeout(() => {
    document.querySelectorAll('[role=notice]').forEach((notice) => {
      notice.classList.add("opacity-0");
    });
  }, 3000);
  document.querySelectorAll('[role=alert], [role=notice]').forEach((alert) => {
    alert.addEventListener('click', () => alert.classList.add("opacity-0"));
  });

  // display charts
  document.querySelectorAll('.chart').forEach((chart) => {
    if (chart.dataset.easyPieChart) return;
    let color = chart.dataset.color
    chart.dataset.easyPieChart = new EasyPieChart(chart, {
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
  });

  // remove tooltip from input[file]
  document.querySelectorAll('.cursor-pointer[type=file]').forEach((input) => {
    input.setAttribute('title', '');
    input.addEventListener('change', () => input.form.submit());
  });
});
