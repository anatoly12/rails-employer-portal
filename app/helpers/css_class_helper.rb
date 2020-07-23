module CssClassHelper
  # ~~ public methods ~~
  def text_field_class(has_error = false)
    base_input_class(has_error) << " appearance-none border-b"
  end

  def text_area_class(has_error = false)
    base_input_class(has_error) << " appearance-none border"
  end

  def select_class(has_error = false)
    base_input_class(has_error) << " bg-white border-b"
  end

  def select_multiple_class(has_error = false)
    base_input_class(has_error) << " bg-white border h-64 px-4 py-4 overflow-y-scroll"
  end

  def link_class
    "text-xs font-bold underline focus:outline-none text-blue-300 hover:text-blue-500 focus:text-blue-500"
  end

  def primary_button_class(color)
    "#{base_button_class(color)} border-2 w-full py-3 font-bold text-lg uppercase tracking-widest"
  end

  def secondary_button_class(color)
    "#{base_button_class(color)} border-2 px-3 py-1 leading-6 font-semibold"
  end

  def thin_button_class(color)
    "#{base_button_class(color)} border inline-block whitespace-no-wrap px-3 leading-tight"
  end

  private

  # ~~ private methods ~~
  def base_input_class(has_error)
    res = "w-full py-1 select-none focus:outline-none"
    if has_error
      res << " text-red-500 border-red-300 focus:text-red-800 focus:border-red-800 placeholder-red-300"
    else
      res << " text-blue-500 focus:text-blue-800 focus:border-blue-800"
    end
  end

  # Do not remove, the following list will be used by PurgeCSS:
  # text-blue-400
  # text-red-400
  # text-gray-400
  # border-blue-400
  # border-red-400
  # border-gray-400
  # hover:border-blue-700
  # hover:border-red-700
  # hover:border-gray-700
  # hover:text-blue-800
  # hover:text-red-800
  # hover:text-gray-800
  # focus:border-blue-700
  # focus:border-red-700
  # focus:border-gray-700
  def base_button_class(color)
    "appearance-none bg-white text-#{color}-400 border-#{color}-400 hover:border-#{color}-700 hover:text-#{color}-800 focus:outline-none focus:border-#{color}-700"
  end
end
