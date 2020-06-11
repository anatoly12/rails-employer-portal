# encoding: utf-8
require 'victor'

task :punchcard do

  cmd = "curl --silent " \
    "--request GET " \
    "--url https://api.github.com/repos/EssentialHealthSolutions/employer-portal/stats/punch_card " \
    "--header 'authorization: Bearer #{ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]}'"
  data = eval(`#{cmd}`)

  RECT_SIZE = 40

  svg = Victor::SVG.new(width: '1120', height: '370', viewBox: "0 0 1120 370")

  svg.build do

    xoff = 130
    yoff = 80
    g(font_size: 18, font_family: 'Helvetica', fill: '#555') do
      %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].each_with_index do |day, idx|
        text(day, x: xoff, y: yoff + (idx * RECT_SIZE), 'text-anchor': 'end')
      end
    end

    xoff = 160
    yoff = 50
    g(font_size: 18, font_family: 'Helvetica', fill: '#555') do
      0.upto 23 do |hour|
        text(hour, x: xoff + (hour * RECT_SIZE), y: yoff, 'text-anchor': 'middle')
      end
    end

    # Punchcard stats are delivered as array of tuples
    # Each tuple looks like [weekday, hour, nr_commits]
    # `points` has weekday * 7 + hour * 23 as its key and nr of commits as its value
    points = {}
    commits_max = 0
    data.each do |datum|
      day = datum[0]
      hour = datum[1]
      nr_commits = datum[2]
      key = day * 7 + hour * 23
      points[key] = nr_commits
      commits_max = [nr_commits, commits_max].max
    end

    xoff = 160
    yoff = 80
    0.upto 6 do |day|
      0.upto 23 do |hour|
        point = points[day * 7 + hour * 23]
        radius = (RECT_SIZE / 2) * point / commits_max.to_f
        x = xoff + hour * RECT_SIZE
        y = yoff + day * RECT_SIZE
        if radius <= 2
          circle(cx: x, cy: y, r: 2, fill: '#ccc')
        else
          circle(cx: x, cy: y, r: radius, fill: '#008')
        end
        rect(x: x - RECT_SIZE / 2,
            y: y - RECT_SIZE / 2,
            width: RECT_SIZE,
            height: RECT_SIZE,
            fill: 'transparent',
            style: { stroke_width: 1, stroke: '#ccc' }) do
            title("#{point} commits")
        end
      end
    end

  end

  svg.save 'punchcard.svg'
  `qlmanage -p punchcard.svg >>/dev/null 2>&1`
  File.delete 'punchcard.svg'
end
