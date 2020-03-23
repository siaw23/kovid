# frozen_string_literal: true

require 'terminal-table'
require_relative 'painter'
require 'date'
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

      def country_table(data)
        headings = CASES_DEATHS_RECOVERED
        rows = [[data['cases'], data['deaths'], data['recovered']]]

        Terminal::Table.new(title: data['country'], headings: headings, rows: rows)
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
        Terminal::Table.new(title: data['country'],
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
        Terminal::Table.new(title: state['state'], headings: headings, rows: rows)
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

        Terminal::Table.new(title: 'Total Number of Incidents Worldwide', headings: headings, rows: rows)
      end

      def history(country)
        headings = DATE_CASES_DEATHS_RECOVERED
        rows = []
        stats = country['timeline'].values.map(&:values).transpose.each do |data|
          data.map! { |number| comma_delimit(number) }
        end

        dates = country['timeline']['cases'].keys

        stats.each_with_index do |val, index|
          val.unshift(Date.parse(Date.strptime(dates[index], '%m/%d/%y').to_s).strftime('%d %b, %y'))
        end.each do |row|
          rows << row
        end

        rows << ['------------', '------------', '------------', '------------']
        rows << DATE_CASES_DEATHS_RECOVERED

        Terminal::Table.new(title: country['standardizedCountryName'].capitalize.to_s, headings: headings, rows: rows)
      end

      private def comma_delimit(number)
        number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(',').reverse
      end
    end
  end
end
