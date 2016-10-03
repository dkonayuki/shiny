require_relative '../paint.rb'
require 'paint'

class String

  Shiny::Paint::COLORS.keys.each do |color|
    define_method("#{color}") do
      Paint[self, Shiny::Paint::COLORS[color]]
    end
  end

end
