module CssClassHelper
  # ~~ public methods ~~
  def text_field_class(has_error = false)
    res = "appearance-none border-b w-full py-1 focus:outline-none"
    if has_error
      res + " text-red-500 border-red-300 focus:text-red-800 focus:border-red-800 placeholder-red-300"
    else
      res + " text-blue-500 focus:text-blue-800 focus:border-blue-800"
    end
  end

  def select_field_class(has_error = false)
    res = "bg-white border-b w-full py-1 focus:outline-none"
    if has_error
      res + " text-red-500 border-red-300 focus:text-red-800 focus:border-red-800 placeholder-red-300"
    else
      res + " text-blue-500 focus:text-blue-800 focus:border-blue-800"
    end
  end

  def primary_link_class
    link_class(true)
  end

  def secondary_link_class
    link_class(false)
  end

  def primary_button_class
    "#{base_button_class("blue")} border-2 w-full py-3 font-bold text-lg uppercase tracking-widest"
  end

  def secondary_button_class(color)
    "#{base_button_class(color)} border-2 px-3 leading-6 font-semibold"
  end

  def thin_button_class
    "#{base_button_class(:blue)} border inline-block whitespace-no-wrap px-3 leading-tight"
  end

  private

  # ~~ private methods ~~
  def link_class(primary)
    res = "text-xs font-bold underline focus:outline-none"
    if primary
      res + " text-blue-400 hover:text-blue-600 focus:text-blue-600"
    else
      res + " text-blue-300 hover:text-blue-500 focus:text-blue-500"
    end
  end

  def base_button_class(color)
    "appearance-none bg-white text-#{color}-400 border-#{color}-400 hover:border-#{color}-700 hover:text-#{color}-800 focus:outline-none focus:border-#{color}-700"
  end
end
