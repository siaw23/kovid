# frozen_string_literal: true

require 'colorize'

class String
  def paint_white
    colorize(:white).colorize(background: :black).colorize(mode: :bold)
  end

  def paint_red
    colorize(:red).colorize(background: :black).colorize(mode: :bold)
  end

  def paint_green
    colorize(:green).colorize(background: :black).colorize(mode: :bold)
  end

  def paint_yellow
    colorize(:yellow).colorize(background: :black).colorize(mode: :bold)
  end
end
