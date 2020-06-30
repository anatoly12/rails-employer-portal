module EmployeesHelper
  # ~~ constants ~~
  TEXT_COLOR_GREEN = "text-green-500"
  TEXT_COLOR_RED = "text-red-600"
  TEXT_COLOR_BLUE = "text-blue-600"
  TEXT_COLOR_GRAY = "text-gray-400"

  # ~~ public methods ~~
  def daily_checkup_color(employee)
    case employee.daily_checkup_status
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
    when "Not Registered"
      TEXT_COLOR_GRAY
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
end
