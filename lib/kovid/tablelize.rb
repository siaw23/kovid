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

      def country_table(data)
        headings = CASES_DEATHS_RECOVERED
        rows = [[data['cases'], data['deaths'], data['recovered']]]

        Terminal::Table.new(title: data['country'].upcase, headings: headings, rows: rows)
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
          data['todayCases'],
          data['todayDeaths'],
          data['critical'],
          data['casesPerOneMillion']
        ]
        Terminal::Table.new(title: data['country'].upcase,
                            headings: headings,
                            rows: rows)
      end

      def full_state_table(state)
        headings = [
          'Cases'.paint_white,
          'Cases Today'.paint_white,
          'Deaths'.paint_red,
          'Deaths Today'.paint_red,
          'Recovered'.paint_green,
          'Active'.paint_yellow
        ]

        rows = []
        rows << [state['cases'], state['todayCases'], state['deaths'], state['todayDeaths'], state['recovered'], state['active']]

        puts
        puts "‼️  Swap value of 'Recovered' for 'Active'. API scraper broke."
        puts "‼️  So 'Active' is #{state['recovered']} and not #{state['active']}."

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
          rows << [country['country'], country['cases'], country['deaths'], country['recovered']]
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
            country['cases'],
            country['deaths'],
            country['recovered'],
            country['todayCases'],
            country['todayDeaths'],
            country['critical'],
            country['casesPerOneMillion']
          ]
        end

        Terminal::Table.new(headings: headings, rows: rows)
      end

      def cases(cases)
        headings = CASES_DEATHS_RECOVERED
        rows = [[cases['cases'], cases['deaths'], cases['recovered']]]

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
    end
  end
end
