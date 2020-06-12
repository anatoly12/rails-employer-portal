module CssClassHelper
  def text_field_class(has_error = false)
    res = "appearance-none border-b w-full py-1 text-gray-700 focus:border-black focus:outline-none"
    if has_error
      res += " placeholder-red-300 border-red-500"
    end
    return res
  end

  def primary_link_class
    link_class(true)
  end

  def secondary_link_class
    link_class(false)
  end

  def primary_button_class
    button_class(true)
  end

  def secondary_button_class
    button_class(false)
  end

  private

  def link_class(primary)
    res = "text-xs font-bold underline focus:outline-none"
    if primary
      res += " text-blue-400 hover:text-blue-600 focus:text-blue-600"
    else
      res += " text-blue-300 hover:text-blue-500 focus:text-blue-500"
    end
    return res
  end

  def button_class(primary)
    res = "appearance-none bg-white text-blue-400 border-blue-400 hover:border-blue-700 hover:text-blue-800 focus:outline-none focus:border-blue-700"
    if primary
      res += " border-2 w-full py-3 font-bold text-lg uppercase tracking-widest"
    else
      res += " border-2 px-3 leading-6 font-semibold"
    end
    return res
  end
end
