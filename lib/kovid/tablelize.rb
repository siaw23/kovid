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
        rows = [
          [
            comma_delimit(data['cases']),
            check_if_positve(data['todayCases']),
            comma_delimit(data['deaths']),
            check_if_positve(data['todayDeaths']),
            comma_delimit(data['recovered'])
          ]
        ]

        if (iso = data['countryInfo']['iso2'])
          title = "#{country_emoji(iso)} #{data['country'].upcase}"
          Terminal::Table.new(title: title,
                              headings: CASES_DEATHS_RECOVERED_CTODAY_DTODAY,
                              rows: rows)
        else
          Terminal::Table.new(title: data['country'].upcase,
                              headings: CASES_DEATHS_RECOVERED_CTODAY_DTODAY,
                              rows: rows)
        end
      end

      def full_country_table(data)
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

        if (iso = data['countryInfo']['iso2'])
          title = "#{country_emoji(iso)} #{data['country'].upcase}"
          Terminal::Table.new(title: title,
                              headings: FULL_COUNTRY_TABLE_HEADINGS,
                              rows: rows)
        else
          Terminal::Table.new(title: data['country'].upcase,
                              headings: FULL_COUNTRY_TABLE_HEADINGS,
                              rows: rows)
        end
      end

      def full_province_table(province)
        headings = [
          'Confirmed'.paint_white,
          'Deaths'.paint_red,
          'Recovered'.paint_green
        ]
        rows = []
        rows << [
          province['stats']['confirmed'],
          province['stats']['deaths'],
          province['stats']['recovered']
        ]

        Terminal::Table.new(
          title: province['province'].upcase, headings: headings, rows: rows
        )
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
        rows << [
          comma_delimit(state['cases']),
          check_if_positve(state['todayCases']),
          comma_delimit(state['deaths']),
          check_if_positve(state['todayDeaths']),
          comma_delimit(state['active'])
        ]

        Terminal::Table.new(
          title: state['state'].upcase, headings: headings, rows: rows
        )
      end

      def compare_countries_table(data)
        rows = []

        data.each do |country|
          base_rows = [
            comma_delimit(country['cases']),
            check_if_positve(country['todayCases']),
            comma_delimit(country['deaths']),
            check_if_positve(country['todayDeaths']),
            comma_delimit(country['recovered'])
          ]

          rows << if (iso = country['countryInfo']['iso2'])
                    c_col = "#{country_emoji(iso)} #{country['country'].upcase}"
                    base_rows.unshift(c_col)
                  else
                    base_rows.unshift(country['country'].upcase.to_s)
                  end
        end

        align_columns(
          :compare_country_table,
          Terminal::Table.new(
            headings: COMPARE_COUNTRIES_TABLE_HEADINGS,
            rows: rows
          )
        )
      end

      def compare_countries_table_full(data)
        rows = data.map do |country|
          [
            country.fetch('country'),
            comma_delimit(country.fetch('cases')),
            comma_delimit(country.fetch('deaths')),
            comma_delimit(country.fetch('recovered')),
            check_if_positve(country.fetch('todayCases')),
            check_if_positve(country.fetch('todayDeaths')),
            comma_delimit(country.fetch('critical')),
            comma_delimit(country.fetch('casesPerOneMillion'))
          ]
        end

        align_columns(:compare_country_table_full,
                      Terminal::Table.new(headings: COMPARE_COUNTRY_TABLE_FULL,
                                          rows: rows))
      end

      def compare_us_states(data)
        rows = data.map.with_index do |state, index|
          if index.odd?
            [
              state.fetch('state').upcase,
              comma_delimit(state.fetch('cases')),
              check_if_positve(state['todayCases']),
              comma_delimit(state['deaths']),
              check_if_positve(state['todayDeaths']),
              comma_delimit(state.fetch('active'))
            ]
          else
            [
              state.fetch('state').upcase.paint_highlight,
              comma_delimit(state.fetch('cases')).paint_highlight,
              check_if_positve(state['todayCases']).paint_highlight,
              comma_delimit(state['deaths']).paint_highlight,
              check_if_positve(state['todayDeaths']).paint_highlight,
              comma_delimit(state.fetch('active')).paint_highlight
            ]
          end
        end

        align_columns(:compare_us_states,
                      Terminal::Table.new(headings: COMPARE_STATES_HEADINGS,
                                          rows: rows))
      end

      def compare_provinces(data)
        rows = data.map do |province|
          [
            province['province'].upcase,
            province['stats']['confirmed'],
            province['stats']['deaths'],
            province['stats']['recovered']
          ]
        end

        align_columns(:compare_provinces,
                      Terminal::Table.new(headings: COMPARE_PROVINCES_HEADINGS,
                                          rows: rows))
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

        Terminal::Table.new(
          title: '🌍 Total Number of Incidents Worldwide'.upcase,
          headings: headings,
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
        COUNTRY_LETTERS.values_at(*iso.chars).pack('U*') + \
          8203.chr(Encoding::UTF_8)
      end

      def transpose(load)
        load['timeline'].values.map(&:values).transpose.each do |data|
          data.map! { |number| comma_delimit(number) }
        end
      end

      def scale(msg)
        rows = [[msg]]
        puts Terminal::Table.new title: 'SCALE', rows: rows
      end

      def aggregated_table(collated_data, continent, iso, emoji)
        aggregated_data_continent = ' Aggregated Data on ' \
                                    "#{continent} (#{iso.size} States)".upcase
        title = if emoji.codepoints.size > 1
                  emoji + 8203.chr(Encoding::UTF_8) + aggregated_data_continent
                else
                  emoji + aggregated_data_continent
                end

        rows = []
        rows << [
          comma_delimit(collated_data['cases']),
          check_if_positve(collated_data['todayCases']),
          comma_delimit(collated_data['deaths']),
          check_if_positve(collated_data['todayDeaths']),
          comma_delimit(collated_data['recovered']),
          comma_delimit(collated_data['active']),
          comma_delimit(collated_data['critical'])
        ]

        Terminal::Table.new(
          title: title,
          headings: CONTINENTAL_AGGREGATE_HEADINGS,
          rows: rows
        )
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
