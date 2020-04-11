# frozen_string_literal: true

require 'terminal-table'
require 'date'
require 'ascii_charts'
require_relative 'painter'
require_relative 'constants'
require_relative 'aggregators'
require_relative 'historians'

module Kovid
  class Tablelize
    extend Kovid::Constants
    extend Kovid::Aggregators
    extend Kovid::Historians

    class << self
      def country_table(data)
        Terminal::Table.new(title: country_title(data),
                            headings: CASES_DEATHS_RECOVERED_CTODAY_DTODAY,
                            rows: [country_row(data)])
      end

      def full_country_table(data)
        Terminal::Table.new(title: country_title(data),
                            headings: FULL_COUNTRY_TABLE_HEADINGS,
                            rows: [full_country_row(data)])
      end

      def full_province_table(province)
        Terminal::Table.new(
          title: province['province'].upcase,
          headings: FULL_PROVINCE_TABLE_HEADINGS,
          rows: [province_row(province)]
        )
      end

      def full_state_table(state)
        Terminal::Table.new(
          title: state['state'].upcase,
          headings: FULL_STATE_TABLE_HEADINGS,
          rows: [country_row(state)]
        )
      end

      def compare_countries_table(data)
        rows = []

        data.each do |country|
          base_rows = country_row(country)
          rows << base_rows.unshift(country_title(country))
        end

        align_columns(:compare_country_table,
                      Terminal::Table.new(
                        headings: COMPARE_COUNTRIES_TABLE_HEADINGS,
                        rows: rows
                      ))
      end

      def compare_countries_table_full(data)
        rows = data.map { |country| compare_countries_full_row(country) }

        align_columns(:compare_country_table_full,
                      Terminal::Table.new(headings: COMPARE_COUNTRY_TABLE_FULL,
                                          rows: rows))
      end

      def compare_us_states(data)
        rows = data.map.with_index do |state, index|
          if index.odd?
            us_state_row(state)
          else
            us_state_row(state).map(&:paint_highlight)
          end
        end

        align_columns(:compare_us_states,
                      Terminal::Table.new(headings: COMPARE_STATES_HEADINGS,
                                          rows: rows))
      end

      def compare_provinces(data)
        rows = data.map { |province| compare_provinces_row(province) }

        align_columns(:compare_provinces,
                      Terminal::Table.new(headings: COMPARE_PROVINCES_HEADINGS,
                                          rows: rows))
      end

      def cases(cases)
        Terminal::Table.new(
          title: '🌍 Total Number of Incidents Worldwide'.upcase,
          headings: CASES_DEATHS_RECOVERED,
          rows: [cases_row(cases)]
        )
      end

      private

      def country_title(data)
        iso = data['countryInfo']['iso2']
        if iso.nil?
          data['country'].upcase
        else
          "#{country_emoji(iso)} #{data['country'].upcase}"
        end
      end

      def country_emoji(iso)
        COUNTRY_LETTERS.values_at(*iso.chars).pack('U*') + \
          8203.chr(Encoding::UTF_8)
      end

      def cases_row(data)
        [
          Kovid.comma_delimit(data['cases']),
          Kovid.comma_delimit(data['deaths']),
          Kovid.comma_delimit(data['recovered'])
        ]
      end

      # Also works for state
      def country_row(data)
        [
          Kovid.comma_delimit(data['cases']),
          Kovid.add_plus_sign(data['todayCases']),
          Kovid.comma_delimit(data['deaths']),
          Kovid.add_plus_sign(data['todayDeaths']),
          Kovid.comma_delimit(data['recovered'])
        ]
      end

      def full_country_row(data)
        [
          Kovid.comma_delimit(data['cases']),
          Kovid.comma_delimit(data['deaths']),
          Kovid.comma_delimit(data['recovered']),
          Kovid.add_plus_sign(data['todayCases']),
          Kovid.add_plus_sign(data['todayDeaths']),
          Kovid.comma_delimit(data['critical']),
          Kovid.comma_delimit(data['casesPerOneMillion'])
        ]
      end

      def province_row(data)
        [
          data['stats']['confirmed'],
          data['stats']['deaths'],
          data['stats']['recovered']
        ]
      end

      def compare_provinces_row(data)
        [
          data['province'].upcase,
          province_row(data)
        ].flatten
      end

      def compare_countries_full_row(data)
        [
          data.fetch('country'),
          full_country_row(data)
        ].flatten
      end

      def us_state_row(data)
        [
          data.fetch('state').upcase,
          Kovid.comma_delimit(data.fetch('cases')),
          Kovid.add_plus_sign(data['todayCases']),
          Kovid.comma_delimit(data['deaths']),
          Kovid.add_plus_sign(data['todayDeaths']),
          Kovid.comma_delimit(data.fetch('active'))
        ]
      end

      def aggregated_row(data)
        [
          Kovid.comma_delimit(data['cases']),
          Kovid.add_plus_sign(data['todayCases']),
          Kovid.comma_delimit(data['deaths']),
          Kovid.add_plus_sign(data['todayDeaths']),
          Kovid.comma_delimit(data['recovered']),
          Kovid.comma_delimit(data['active']),
          Kovid.comma_delimit(data['critical'])
        ]
      end

      def scale(msg)
        rows = [[msg]]
        puts Terminal::Table.new title: 'SCALE', rows: rows
      end

      def aggregated_table(collated_data, continent, iso, emoji)
        title = aggregated_table_title(continent, iso, emoji)

        Terminal::Table.new(
          title: title,
          headings: CONTINENTAL_AGGREGATE_HEADINGS,
          rows: [aggregated_row(collated_data)]
        )
      end

      def aggregated_table_title(continent, iso, emoji)
        aggregated_data_continent = ' Aggregated Data on ' \
          "#{continent} (#{iso.size} States)".upcase

        if emoji.codepoints.size > 1
          emoji + 8203.chr(Encoding::UTF_8) + aggregated_data_continent
        else
          emoji + aggregated_data_continent
        end
      end

      def align_columns(table_type, table)
        return table unless RIGHT_ALIGN_COLUMNS[table_type]

        RIGHT_ALIGN_COLUMNS[table_type].each do |col_no|
          table.align_column(col_no, :right)
        end
        table
      end
    end
  end
end
