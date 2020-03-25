# frozen_string_literal: true

require 'terminal-table'
require 'date'
require_relative 'painter'

module Kovid
  class Tablelize
    class << self
      CASES_DEATHS_RECOVERED = [
        'Cases'.paint_white,
        'Deaths'.paint_red,
        'Recovered'.paint_green
      ].freeze

      DATE_CASES_DEATHS_RECOVERED = [
        'Date'.paint_white,
        'Cases'.paint_white,
        'Deaths'.paint_red,
        'Recovered'.paint_green
      ].freeze

      FOOTER_LINE = ['------------', '------------', '------------', '------------'].freeze
      COUNTRY_LETTERS = 'A'.upto('Z').with_index(127_462).to_h.freeze

      def country_table(data)
        headings = CASES_DEATHS_RECOVERED
        rows = [[data['cases'], data['deaths'], data['recovered']]]

        if iso = data['countryInfo']['iso2']
          Terminal::Table.new(title: data['country'].upcase.to_s, headings: headings, rows: rows)
        else
          Terminal::Table.new(title: data['country'].upcase, headings: headings, rows: rows)
        end
        # TODO: Rafactor this
        # TODO: Fix emoji
      end

      def full_country_table(data)
        headings = [
          'Cases'.paint_white,
          'Deaths'.paint_red,
          'Recovered'.paint_green,
          'Cases Today'.paint_white,
          'Deaths Today'.paint_red,
          'Critical'.paint_yellow,
          'Cases/Million'.paint_white
        ]

        rows = []
        rows << [
          data['cases'],
          data['deaths'],
          data['recovered'],
          check_if_positve(data['todayCases']),
          check_if_positve(data['todayDeaths']),
          data['critical'],
          data['casesPerOneMillion']
        ]

        # if iso = data['countryInfo']['iso2']
        #   Terminal::Table.new(title: "#{data['country'].upcase} #{country_emoji(iso)}",
        #                       headings: headings,
        #                       rows: rows)
        # else
        Terminal::Table.new(title: data['country'].upcase,
                            headings: headings,
                            rows: rows)
        # end
        # TODO: Rafactor this
      end

      def full_state_table(state)
        headings = [
          'Cases'.paint_white,
          'Cases Today'.paint_white,
          'Deaths'.paint_red,
          'Deaths Today'.paint_red,
          'Active'.paint_yellow
        ]

        rows = []
        rows << [state['cases'], check_if_positve(state['todayCases']), state['deaths'], check_if_positve(state['todayDeaths']), state['active']]

        Terminal::Table.new(title: state['state'].upcase, headings: headings, rows: rows)
      end

      def compare_countries_table(data)
        headings = [
          'Country'.paint_white,
          'Cases'.paint_white,
          'Deaths'.paint_red,
          'Recovered'.paint_green
        ]

        rows = []

        data.each do |country|
          rows << [country['country'].upcase, comma_delimit(country['cases']), comma_delimit(country['deaths']), comma_delimit(country['recovered'])]
        end

        Terminal::Table.new(headings: headings, rows: rows)
      end

      def compare_countries_table_full(data)
        headings = [
          'Country'.paint_white,
          'Cases'.paint_white,
          'Deaths'.paint_red,
          'Recovered'.paint_green,
          'Cases Today'.paint_white,
          'Deaths Today'.paint_red,
          'Critical'.paint_yellow,
          'Cases/Million'.paint_white
        ]

        rows = []

        data.each do |country|
          rows << [
            country['country'],
            comma_delimit(country['cases']),
            comma_delimit(country['deaths']),
            comma_delimit(country['recovered']),
            check_if_positve(country['todayCases']),
            check_if_positve(country['todayDeaths']),
            comma_delimit(country['critical']),
            comma_delimit(country['casesPerOneMillion'])
          ]
        end

        Terminal::Table.new(headings: headings, rows: rows)
      end

      def cases(cases)
        headings = CASES_DEATHS_RECOVERED
        rows = [
          [
            comma_delimit(cases['cases']),
            comma_delimit(cases['deaths']),
            comma_delimit(cases['recovered'])
          ]
        ]

        Terminal::Table.new(title: 'Total Number of Incidents Worldwide'.upcase, headings: headings, rows: rows)
      end

      def history(country, last)
        headings = DATE_CASES_DEATHS_RECOVERED
        rows = []

        stats = if last
                  country['timeline'].values.map(&:values).transpose.each do |data|
                    data.map! { |number| comma_delimit(number) }
                  end.last(last.to_i)
                else
                  country['timeline'].values.map(&:values).transpose.each do |data|
                    data.map! { |number| comma_delimit(number) }
                  end
                end

        dates = if last
                  country['timeline']['cases'].keys.last(last.to_i)
                else
                  country['timeline']['cases'].keys
                end

        stats.each_with_index do |val, index|
          val.unshift(Date.parse(Date.strptime(dates[index], '%m/%d/%y').to_s).strftime('%d %b, %y'))
        end.each do |row|
          rows << row
        end

        if stats.size > 10
          rows << FOOTER_LINE
          rows << DATE_CASES_DEATHS_RECOVERED
        end

        Terminal::Table.new(title: country['standardizedCountryName'].upcase, headings: headings, rows: rows)
      end

      private

      def comma_delimit(number)
        number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(',').reverse
      end

      def check_if_positve(num)
        num.to_i.positive? ? "+#{comma_delimit(num)}" : comma_delimit(num).to_s
      end

      def country_emoji(iso)
        COUNTRY_LETTERS.values_at(*iso.chars).pack('U*')
      end
    end
  end
end
