# frozen_string_literal: true

module Kovid
  module AsciiCharts
    VERSION = '0.9.1'

    class Chart
      attr_reader :options, :data

      DEFAULT_MAX_Y_VALS = 20
      DEFAULT_MIN_Y_VALS = 10

      # data is a sorted array of [x, y] pairs

      def initialize(data, options = {})
        @data = data
        @options = options
      end

      def rounded_data
        @rounded_data ||= data.map { |pair| [pair[0], round_value(pair[1])] }
      end

      def step_size
        unless defined? @step_size
          if options[:y_step_size]
            @step_size = options[:y_step_size]
          else
            max_y_vals = options[:max_y_vals] || DEFAULT_MAX_Y_VALS
            min_y_vals = options[:max_y_vals] || DEFAULT_MIN_Y_VALS
            y_span = (max_yval - min_yval).to_f

            step_size = nearest_step(y_span.to_f / (data.size + 1))

            if @all_ints && (step_size < 1)
              step_size = 1
            else
              while (y_span / step_size) < min_y_vals
                candidate_step_size = next_step_down(step_size)
                if @all_ints && (candidate_step_size < 1)
                  break
                  end ## don't go below one

                step_size = candidate_step_size
              end
            end

            # go up if we undershot, or were never over
            while (y_span / step_size) > max_y_vals
              step_size = next_step_up(step_size)
            end
            @step_size = step_size
          end
          if !@all_ints && @step_size.is_a?(Integer)
            @step_size = @step_size.to_f
          end
        end
        @step_size
      end

      STEPS = [1, 2, 5].freeze

      def from_step(val)
        if val == 0
          [0, 0]
        else
          order = Math.log10(val).floor.to_i
          num = (val / (10**order))
          [num, order]
        end
      end

      def to_step(num, order)
        s = num * (10**order)
        if order < 0
          s.to_f
        else
          s
        end
      end

      def nearest_step(val)
        num, order = from_step(val)
        to_step(2, order) # #@@
      end

      def next_step_up(val)
        num, order = from_step(val)
        next_index = STEPS.index(num.to_i) + 1
        if STEPS.size == next_index
          next_index = 0
          order += 1
        end
        to_step(STEPS[next_index], order)
      end

      def next_step_down(val)
        num, order = from_step(val)
        next_index = STEPS.index(num.to_i) - 1
        if next_index == -1
          STEPS.size - 1
          order -= 1
        end
        to_step(STEPS[next_index], order)
      end

      # round to nearest step size, making sure we curtail precision to same order of magnitude as the step size to avoid 0.4 + 0.2 = 0.6000000000000001
      def round_value(val)
        remainder = val % step_size
        unprecised = if (remainder * 2) >= step_size
                       (val - remainder) + step_size
                     else
                       val - remainder
                      end
        if step_size < 1
          precision = -Math.log10(step_size).floor
          (unprecised * (10**precision)).to_i.to_f / (10**precision)
        else
          unprecised
        end
      end

      def max_yval
        scan_data unless defined? @max_yval
        @max_yval
      end

      def min_yval
        scan_data unless defined? @min_yval
        @min_yval
      end

      def all_ints
        scan_data unless defined? @all_ints
        @all_ints
      end

      def scan_data
        @max_yval = 0
        @min_yval = 0
        @all_ints = true

        @max_xval_width = 1

        data.each do |pair|
          @max_yval = pair[1] if pair[1] > @max_yval
          @min_yval = pair[1] if pair[1] < @min_yval
          @all_ints = false if @all_ints && !pair[1].is_a?(Integer)

          if (xw = pair[0].to_s.length) > @max_xval_width
            @max_xval_width = xw
          end
        end
      end

      def max_xval_width
        scan_data unless defined? @max_xval_width
        @max_xval_width
      end

      def max_yval_width
        scan_y_range unless defined? @max_yval_width
        @max_yval_width
      end

      def scan_y_range
        @max_yval_width = 1

        y_range.each do |yval|
          if (yw = yval.to_s.length) > @max_yval_width
            @max_yval_width = yw
          end
        end
      end

      def y_range
        unless defined? @y_range
          @y_range = []
          first_y = round_value(min_yval)
          first_y -= step_size if first_y > min_yval
          last_y = round_value(max_yval)
          last_y += step_size if last_y < max_yval
          current_y = first_y
          while current_y <= last_y
            @y_range << current_y
            current_y = round_value(current_y + step_size) ## to avoid fp arithmetic oddness
          end
        end
        @y_range
      end

      def lines
        raise 'lines must be overridden'
      end

      def draw
        lines.join("\n")
      end

      def to_string
        draw
      end
    end

    class Cartesian < Chart
      def lines
        return [[' ', options[:title], ' ', '|', '+-', ' ']] if data.empty?

        lines = [' ']

        bar_width = max_xval_width + 1

        lines << (' ' * max_yval_width) + ' ' + rounded_data.map { |pair| pair[0].to_s.center(bar_width) }.join('')

        y_range.each_with_index do |current_y, i|
          yval = current_y.to_s
          bar = if i == 0
                  '+'
                else
                  '|'
                end
          current_line = [(' ' * (max_yval_width - yval.length)) + "#{current_y}#{bar}"]

          rounded_data.each do |pair|
            marker = if (i == 0) && options[:hide_zero]
                       '-'
                     else
                       '*'
                     end
            filler = if i == 0
                       '-'
                     else
                       ' '
                     end
            comparison = if options[:bar]
                           current_y <= pair[1]
                         else
                           current_y == pair[1]
                         end
            current_line << if comparison
                              marker.center(bar_width, filler)
                            else
                              filler * bar_width
                            end
          end
          lines << current_line.join('')
          current_y += step_size
        end
        lines << ' '
        lines << options[:title].center(lines[1].length) if options[:title]
        lines << ' '
        lines.reverse
      end
    end
    end
end
