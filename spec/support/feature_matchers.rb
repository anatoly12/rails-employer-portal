RSpec::Matchers.define :have_form_errors do |errors|
  match do
    expect(page).to have_css "p.text-red-400", count: errors.size
    errors.each do |input_id, message|
      input = page.find_by_id input_id
      error = if input[:type] == "checkbox"
          input.ancestor("label").sibling "p.text-red-400"
        else
          input.sibling "p.text-red-400"
        end
      expect(error.text).to eql message
    end
  end
end

RSpec::Matchers.define :have_charts do |*color_and_percent|
  match do
    charts = page.all ".chart"
    color_and_percent.each_with_index do |(color, percent), index|
      chart = charts[index]
      expect(chart["data-color"]).to eql color
      expect(chart["data-percent"]).to eql percent.to_s
    end
  end
end

RSpec::Matchers.define :have_employees do |*employees|
  match do
    employee_links = page.all "a[href$='/edit']"
    expect(employee_links.size).to eql employees.size
    employees.each_with_index do |employee, index|
      employee_link = employee_links[index]
      expect(employee_link[:href]).to eql "/employees/#{employee.uuid}/edit"
      within employee_link do
        expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
        expect(page).to have_css "div:nth-child(3)", text: employee.state
      end
    end
  end
end
