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

      CASES_DEATHS_RECOVERED_CTODAY_DTODAY = [
        'Cases'.paint_white,
        'Deaths'.paint_red,
        'Recovered'.paint_green,
        'Cases Today'.paint_white,
        'Deaths Today'.paint_red
      ].freeze

      DATE_CASES_DEATHS = [
        'Date'.paint_white,
        'Cases'.paint_white,
        'Deaths'.paint_red
      ].freeze

      EU_AGGREGATE_HEADINGS = [
        'Cases'.paint_white,
        'Cases Today'.paint_white,
        'Deaths'.paint_red,
        'Deaths Today'.paint_red,
        'Recovered'.paint_green,
        'Active'.paint_yellow,
        'Critical'.paint_red
      ].freeze

      FOOTER_LINE = ['------------', '------------', '------------'].freeze
      COUNTRY_LETTERS = 'A'.upto('Z').with_index(127_462).to_h.freeze

      def country_table(data)
        headings = CASES_DEATHS_RECOVERED_CTODAY_DTODAY
        rows = [
          [
            comma_delimit(data['cases']),
            comma_delimit(data['deaths']),
            comma_delimit(data['recovered']),
            check_if_positve(data['todayCases']),
            check_if_positve(data['todayDeaths'])
          ]
        ]

        if iso = data['countryInfo']['iso2']
          Terminal::Table.new(title: "#{country_emoji(iso)} #{data['country'].upcase}", headings: headings, rows: rows)
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
          comma_delimit(data['cases']),
          comma_delimit(data['deaths']),
          comma_delimit(data['recovered']),
          check_if_positve(data['todayCases']),
          check_if_positve(data['todayDeaths']),
          comma_delimit(data['critical']),
          comma_delimit(data['casesPerOneMillion'])
        ]

        if iso = data['countryInfo']['iso2']
          Terminal::Table.new(title: "#{country_emoji(iso)} #{data['country'].upcase}",
                              headings: headings,
                              rows: rows)
        else
          Terminal::Table.new(title: data['country'].upcase,
                              headings: headings,
                              rows: rows)
        end
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
          'Recovered'.paint_green,
          'Cases Today'.paint_white,
          'Deaths Today'.paint_red
        ]

        rows = []

        data.each do |country|
          rows << [
            country['country'].upcase,
            comma_delimit(country['cases']),
            comma_delimit(country['deaths']),
            comma_delimit(country['recovered']),
            check_if_positve(country['todayCases']),
            check_if_positve(country['todayDeaths'])
          ]
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

        Terminal::Table.new(title: '🌍 Total Number of Incidents Worldwide'.upcase, headings: headings, rows: rows)
      end

      def history(country, last)
        headings = DATE_CASES_DEATHS
        rows = []

        stats = if last
                  transpose(country).last(last.to_i)
                else
                  transpose(country)
                end

        dates = if last
                  country['timeline']['cases'].keys.last(last.to_i)
                else
                  country['timeline']['cases'].keys
                end

        unless last
          stats = stats.reject! { |stat| stat[0].to_i.zero? && stat[1].to_i.zero? }
          dates = dates.last(stats.count)
        end

        stats.each_with_index do |val, index|
          date_to_parse = Date.strptime(dates[index], '%m/%d/%y').to_s
          val.unshift(Date.parse(date_to_parse).strftime('%d %b, %y'))
        end.each do |row|
          rows << row
        end

        if stats.size > 10
          rows << FOOTER_LINE
          rows << DATE_CASES_DEATHS
        end

        Terminal::Table.new(
          title: country['country'].upcase,
          headings: headings,
          rows: rows
        )
      end

      def eu_aggregate(eu_data)
        rows = []
        rows << [
          comma_delimit(eu_data['cases']),
          check_if_positve(eu_data['todayCases']),
          comma_delimit(eu_data['deaths']),
          check_if_positve(eu_data['todayDeaths']),
          comma_delimit(eu_data['recovered']),
          comma_delimit(eu_data['active']),
          comma_delimit(eu_data['critical'])
        ]

        Terminal::Table.new(
          title: '🇪🇺' + 8203.chr(Encoding::UTF_8) + ' Aggregated EU (27 States) Data'.upcase,
          headings: EU_AGGREGATE_HEADINGS,
          rows: rows
        )
      end

      private

      def comma_delimit(number)
        number.to_s.chars.to_a.reverse.each_slice(3)
              .map(&:join)
              .join(',')
              .reverse
      end

      def check_if_positve(num)
        num.to_i.positive? ? "+#{comma_delimit(num)}" : comma_delimit(num).to_s
      end

      def country_emoji(iso)
        COUNTRY_LETTERS.values_at(*iso.chars).pack('U*') + 8203.chr(Encoding::UTF_8)
      end

      def transpose(load)
        load['timeline'].values.map(&:values).transpose.each do |data|
          data.map! { |number| comma_delimit(number) }
        end
      end
    end
  end
end
