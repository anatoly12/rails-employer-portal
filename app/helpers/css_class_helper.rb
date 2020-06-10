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

  def primary_button_class
    button_class(true)
  end

  def secondary_link_class
    link_class(true)
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
    res = "appearance-none border-2 w-full py-3 font-bold focus:outline-none"
    if primary
      res += " text-lg uppercase tracking-widest text-blue-400 border-blue-400 hover:border-blue-800 focus:border-blue-800"
    end
    return res
  end

end
