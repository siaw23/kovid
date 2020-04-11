# frozen_string_literal: true

module Kovid
  # Constructs history data for specified country
  module Historians
    include Constants

    def history(country, last)
      # Write checks for when country is spelt wrong.
      headings = DATE_CASES_DEATHS_RECOVERED
      rows = []

      stats = if last
                Kovid.format_country_history_numbers(country).last(last.to_i)
              else
                Kovid.format_country_history_numbers(country)
              end

      dates = if last
                country['timeline']['cases'].keys.last(last.to_i)
              else
                country['timeline']['cases'].keys
              end

      unless last
        stats = stats.reject { |stat| stat[0].to_i.zero? && stat[1].to_i.zero? }
        dates = dates.last(stats.count)
      end

      stats.each_with_index do |val, index|
        val.unshift(Kovid.dateman(dates[index]))
      end.each do |row|
        rows << row
      end

      if stats.size > 10
        rows << FOOTER_LINE
        rows << DATE_CASES_DEATHS_RECOVERED
      end

      Terminal::Table.new(
        title: country['country'].upcase,
        headings: headings,
        rows: rows
      )
    end

    def histogram(country, date_string)
      @date = date_string.split('.')

      if @date.last.to_i != 20
        Kovid.info_table('Only 2020 histgrams are available.')
        return
      end

      # From dates where number of !cases.zero?
      country_cases = country['timeline']['cases']
      positive_cases_figures = country_cases.values.reject(&:zero?)
      dates = country_cases.reject { |_k, v| v.zero? }.keys
      data = []

      # TODO: Refactor
      # Returns array of days.to_i from the date param
      dates = dates.map do |date|
        date.split('/')
      end.select do |date|
        date.last == @date.last
      end.select do |date|
        date.first == @date.first
      end.map do |array|
        array[1]
      end.map(&:to_i).last(positive_cases_figures.count)

      # Arranges dates and figures in [x,y] for histogram
      # With x being day, y being number of cases
      if dates.empty?
        if @date.first.to_i > Time.now.month
          msgs = [
            'Seriously...??! 😏', 'Did you just check the future??',
            'You just checked the future Morgan.',
            'Knowing too much of your future is never a good thing.'
          ]

          Kovid.info_table(msgs.sample)
        else
          Kovid.info_table('Check your spelling/No infections for this month.')
        end

      else
        dates.each_with_index do |val, index|
          data << [val, positive_cases_figures[index]]
        end
        y_range = AsciiCharts::Cartesian.new(
          data, bar: true, hide_zero: true
        ).y_range

        last_two_y = y_range.last 2
        y_interval = last_two_y.last - last_two_y.first

        scale("Scale on Y: #{y_interval}:#{(
          y_interval / last_two_y.last.to_f * positive_cases_figures.last
        ).round(2) / y_interval}")

        puts 'Experimental feature, please report issues.'

        AsciiCharts::Cartesian.new(data, bar: true, hide_zero: true).draw
      end
    end
  end
end
