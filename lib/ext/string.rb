require_relative '../paint.rb'
require 'paint'

class String
  def base03
    Paint[self, Shiny::Paint::COLORS[:base03]]
  end
end
