require "css_parser"

class EmployerPortal::ColorPalette

  # ~~ constants ~~
  CACHE = ::EmployerPortal::MemoryCache.new 100

  def initialize(company)
    @company = company
  end

  def used_colors
    @used_colors ||= default_colors.keys.select { |color| configurable? color }
  end

  def default_value(color)
    default_colors[color]
  end

  def current_value(color)
    colors[color]
  end

  def css_overrides
    return unless parser && color_overrides.any?

    new_parser = CssParser::Parser.new
    if color_overrides.any? { |color, _| color.starts_with? "gradient-" }
      new_parser.add_rule! ".bg-gradient", "background-image: linear-gradient(to bottom, #{colors["gradient-top"]} 0%, #{colors["gradient-bottom"]} 100%);"
    end
    parser.each_selector.each do |selector, declarations|
      matching = color_overrides.select do |color, _|
        selector.include? "-#{color}"
      end
      if matching.any?
        rgb = hex_to_rgb matching.values.first
        replaced = declarations.split(";").select do |declaration|
          declaration.include? "rgba"
        end.map do |declaration|
          declaration.gsub(/rgba\(\d+,\d+,\d+,/, "rgba(#{rgb.join(",")},").strip
        end.join ";"
        new_parser.add_rule! selector, replaced
      end
    end
    new_parser.to_s
  end

  private

  attr_reader :company

  def parser
    return @parser if defined? @parser
    @parser = begin
        path = Rails.root.join "public", "packs", "css", "application-*.css"
        file = Dir.glob(path).max_by { |f| File.mtime(f) }
        if file
          parser = CssParser::Parser.new
          parser.load_file! file
          parser
        else
          false
        end
      end
  end

  def configurable?(color)
    configurable = CACHE.get color
    configurable ||= configurable_without_cache? color
    CACHE.set color, configurable
    configurable
  end

  def configurable_without_cache?(color)
    return true unless parser
    return true if color.starts_with?("gradient") || color.starts_with?("chart")

    parser.each_selector.any? { |selector| selector.include? "-#{color}" }
  end

  def default_colors
    {
      "gradient-top" => "#17a9e6",
      "gradient-bottom" => "#1394c9",
      "chart-cleared" => "#1dd678",
      "chart-not-cleared" => "#f35200",
      "chart-pending" => "#16a3e5",
      "chart-disabled" => "#718096",
      "black" => "#000000",
      "white" => "#ffffff",
      "gray-100" => "#f7fafc",
      "gray-200" => "#edf2f7",
      "gray-300" => "#e2e8f0",
      "gray-400" => "#cbd5e0",
      "gray-500" => "#a0aec0",
      "gray-600" => "#718096",
      "gray-700" => "#4a5568",
      "gray-800" => "#2d3748",
      "gray-900" => "#1a202c",
      "red-100" => "#fff5f5",
      "red-200" => "#fed7d7",
      "red-300" => "#feb2b2",
      "red-400" => "#fc8181",
      "red-500" => "#f56565",
      "red-600" => "#e53e3e",
      "red-700" => "#c53030",
      "red-800" => "#9b2c2c",
      "red-900" => "#742a2a",
      "orange-100" => "#fffaf0",
      "orange-200" => "#feebc8",
      "orange-300" => "#fbd38d",
      "orange-400" => "#f6ad55",
      "orange-500" => "#ed8936",
      "orange-600" => "#dd6b20",
      "orange-700" => "#c05621",
      "orange-800" => "#9c4221",
      "orange-900" => "#7b341e",
      "yellow-100" => "#fffff0",
      "yellow-200" => "#fefcbf",
      "yellow-300" => "#faf089",
      "yellow-400" => "#f6e05e",
      "yellow-500" => "#ecc94b",
      "yellow-600" => "#d69e2e",
      "yellow-700" => "#b7791f",
      "yellow-800" => "#975a16",
      "yellow-900" => "#744210",
      "green-100" => "#f0fff4",
      "green-200" => "#c6f6d5",
      "green-300" => "#9ae6b4",
      "green-400" => "#68d391",
      "green-500" => "#48bb78",
      "green-600" => "#38a169",
      "green-700" => "#2f855a",
      "green-800" => "#276749",
      "green-900" => "#22543d",
      "teal-100" => "#e6fffa",
      "teal-200" => "#b2f5ea",
      "teal-300" => "#81e6d9",
      "teal-400" => "#4fd1c5",
      "teal-500" => "#38b2ac",
      "teal-600" => "#319795",
      "teal-700" => "#2c7a7b",
      "teal-800" => "#285e61",
      "teal-900" => "#234e52",
      "blue-100" => "#ebf8ff",
      "blue-200" => "#bee3f8",
      "blue-300" => "#90cdf4",
      "blue-400" => "#63b3ed",
      "blue-500" => "#4299e1",
      "blue-600" => "#3182ce",
      "blue-700" => "#2b6cb0",
      "blue-800" => "#2c5282",
      "blue-900" => "#2a4365",
      "indigo-100" => "#ebf4ff",
      "indigo-200" => "#c3dafe",
      "indigo-300" => "#a3bffa",
      "indigo-400" => "#7f9cf5",
      "indigo-500" => "#667eea",
      "indigo-600" => "#5a67d8",
      "indigo-700" => "#4c51bf",
      "indigo-800" => "#434190",
      "indigo-900" => "#3c366b",
      "purple-100" => "#faf5ff",
      "purple-200" => "#e9d8fd",
      "purple-300" => "#d6bcfa",
      "purple-400" => "#b794f4",
      "purple-500" => "#9f7aea",
      "purple-600" => "#805ad5",
      "purple-700" => "#6b46c1",
      "purple-800" => "#553c9a",
      "purple-900" => "#44337a",
      "pink-100" => "#fff5f7",
      "pink-200" => "#fed7e2",
      "pink-300" => "#fbb6ce",
      "pink-400" => "#f687b3",
      "pink-500" => "#ed64a6",
      "pink-600" => "#d53f8c",
      "pink-700" => "#b83280",
      "pink-800" => "#97266d",
      "pink-900" => "#702459",
    }
  end

  def color_overrides
    company.color_overrides || {}
  end

  def colors
    @colors ||= default_colors.merge color_overrides
  end

  def hex_to_rgb(hex)
    if hex.match(/#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})/)
      [$1.hex, $2.hex, $3.hex]
    else
      [0, 0, 0]
    end
  end
end
