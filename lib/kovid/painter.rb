# frozen_string_literal: true

require 'rainbow'

class String
  def paint_white
    Rainbow(self).white.bg(:black).bold
  end

  def paint_red
    Rainbow(self).red.bg(:black).bold
  end

  def paint_green
    Rainbow(self).green.bg(:black).bold
  end

  def paint_yellow
    Rainbow(self).yellow.bg(:black).bold
  end
end
