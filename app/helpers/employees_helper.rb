module EmployeesHelper
  # ~~ constants ~~
  TEXT_COLOR_GREEN = "text-green-500"
  TEXT_COLOR_RED = "text-red-600"
  TEXT_COLOR_BLUE = "text-blue-600"
  TEXT_COLOR_DISABLED = "text-gray-600"

  # ~~ public methods ~~
  def employee_row_class(employee)
    res = "flex items-center border-t text-gray-300"
    if employee.active?
      res << " hover:bg-gray-100"
    else
      res << " bg-gray-200 opacity-50"
    end
    if employee.flagged?
      res << " hover:text-red-600"
    else
      res << " hover:text-blue-600"
    end
    res
  end

  def daily_checkup_color(employee)
    case employee.daily_checkup_status
    when "Deactivated"
      TEXT_COLOR_DISABLED
    when "Cleared"
      TEXT_COLOR_GREEN
    when "Not Cleared"
      TEXT_COLOR_RED
    else # "Did Not Submit"
      TEXT_COLOR_BLUE
    end
  end

  def testing_color(employee)
    case employee.testing_status
    when "Deactivated"
      TEXT_COLOR_DISABLED
    when "Cleared"
      TEXT_COLOR_GREEN
    when "Inconclusive"
      TEXT_COLOR_RED
    else # "Submitted Results", "Intake", "Registered"
      TEXT_COLOR_BLUE
    end
  end

  def temperature_color(symptom_log)
    temperature = symptom_log.temperature.to_s.upcase
    fahrenheit = if temperature.include? "C"
        temperature.to_f * 9 / 5 + 32
      else
        temperature.to_f
      end
    TEXT_COLOR_RED if (fahrenheit * 10).floor >= 1004
  end

  def testing_status_color(health_passport)
    case health_passport.status
    when "Cleared"
      "text-green-500 border-green-500"
    when "Not Cleared"
      "text-red-600 border-red-600"
    else
      "text-blue-600 border-blue-600"
    end
  end

  def health_passport_color(health_passport)
    if health_passport.status_cleared?
      "bg-green-500"
    elsif health_passport.status_not_cleared?
      "bg-red-600"
    else
      "bg-blue-600"
    end
  end
end
