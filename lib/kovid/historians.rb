# frozen_string_literal: true

module Kovid
  module Historians
    include Constants
    include AsciiCharts

    def history(data, days)
      rows = history_rows(data, days)

      if rows.size > ADD_FOOTER_SIZE
        rows << FOOTER_LINE_FOUR_COLUMNS
        rows << DATE_CASES_DEATHS_RECOVERED
      end

      Terminal::Table.new(
        title: data['country']&.upcase,
        headings: DATE_CASES_DEATHS_RECOVERED,
        rows: rows
      )
    end

    def history_us_state(data, days)
      rows = history_rows(data, days)

      if rows.size > ADD_FOOTER_SIZE
        rows << FOOTER_LINE_THREE_COLUMNS
        rows << DATE_CASES_DEATHS 
      end

      Terminal::Table.new(
        title: data['state']&.upcase,
        headings:  DATE_CASES_DEATHS,
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
        y_range = Kovid::AsciiCharts::Cartesian.new(
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

    private

      def history_rows(data, days)
        data['timeline']['cases'].map do |date, cases|
          formatted_date = Kovid.dateman(date)
          cases          = Kovid.comma_delimit(cases)
          deaths         = Kovid.comma_delimit(data['timeline']['deaths'][date])
          recovered      = Kovid.comma_delimit(data['timeline']['recovered'][date]) if data['timeline'].has_key? 'recovered'

          row = [formatted_date, cases, deaths]
          row << recovered unless recovered.nil?
          row
        end.last(days.to_i)
      end
  end
end
