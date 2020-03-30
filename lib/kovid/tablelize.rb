# frozen_string_literal: true

require 'terminal-table'
require 'date'
require 'ascii_charts'
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

      CONTINENTAL_AGGREGATE_HEADINGS = [
        'Cases'.paint_white,
        'Cases Today'.paint_white,
        'Deaths'.paint_red,
        'Deaths Today'.paint_red,
        'Recovered'.paint_green,
        'Active'.paint_yellow,
        'Critical'.paint_red
      ].freeze

      COMPARE_COUNTRY_TABLE_FULL = [
        'Country'.paint_white,
        'Cases'.paint_white,
        'Deaths'.paint_red,
        'Recovered'.paint_green,
        'Cases Today'.paint_white,
        'Deaths Today'.paint_red,
        'Critical'.paint_yellow,
        'Cases/Million'.paint_white
      ].freeze

      COMPARE_COUNTRIES_TABLE_HEADINGS = [
        'Country'.paint_white,
        'Cases'.paint_white,
        'Cases Today'.paint_white,
        'Deaths'.paint_red,
        'Deaths Today'.paint_red,
        'Recovered'.paint_green
      ].freeze

      FULL_COUNTRY_TABLE_HEADINGS = [
        'Cases'.paint_white,
        'Deaths'.paint_red,
        'Recovered'.paint_green,
        'Cases Today'.paint_white,
        'Deaths Today'.paint_red,
        'Critical'.paint_yellow,
        'Cases/Million'.paint_white
      ].freeze

      COMPARE_STATES_HEADINGS = [
        'State'.paint_white,
        'Cases'.paint_white,
        'Cases Today'.paint_white,
        'Deaths'.paint_red,
        'Deaths Today'.paint_red,
        'Active'.paint_yellow
      ].freeze

      FOOTER_LINE = ['------------', '------------', '------------'].freeze
      COUNTRY_LETTERS = 'A'.upto('Z').with_index(127_462).to_h.freeze

      def country_table(data)
        rows = [
          [
            comma_delimit(data['cases']),
            comma_delimit(data['deaths']),
            comma_delimit(data['recovered']),
            check_if_positve(data['todayCases']),
            check_if_positve(data['todayDeaths'])
          ]
        ]

        if (iso = data['countryInfo']['iso2'])
          Terminal::Table.new(title: "#{country_emoji(iso)} #{data['country'].upcase}",
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

        if iso = data['countryInfo']['iso2']
          Terminal::Table.new(title: "#{country_emoji(iso)} #{data['country'].upcase}",
                              headings: FULL_COUNTRY_TABLE_HEADINGS,
                              rows: rows)
        else
          Terminal::Table.new(title: data['country'].upcase,
                              headings: FULL_COUNTRY_TABLE_HEADINGS,
                              rows: rows)
        end
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
                    base_rows.unshift("#{country_emoji(iso)} #{country['country'].upcase}")
                  else
                    base_rows.unshift(country['country'].upcase.to_s)
                  end
        end

        Terminal::Table.new(headings: COMPARE_COUNTRIES_TABLE_HEADINGS, rows: rows)
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

        Terminal::Table.new(headings: COMPARE_COUNTRY_TABLE_FULL, rows: rows)
      end

      def compare_us_states(data)
        rows = data.map do |state|
          [
            state.fetch('state').upcase,
            comma_delimit(state.fetch('cases')),
            check_if_positve(state['todayCases']),
            comma_delimit(state['deaths']),
            check_if_positve(state['todayDeaths']),
            comma_delimit(state.fetch('active'))
          ]
        end

        Terminal::Table.new(headings: COMPARE_STATES_HEADINGS, rows: rows)
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
        # Write checks for when country is spelt wrong.
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
          stats = stats.reject { |stat| stat[0].to_i.zero? && stat[1].to_i.zero? }
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

      def histogram(country, date_string)
        @date = date_string.split('.')

        if @date.last.to_i != 20
          Kovid.info_table('Only 2020 histgrams are available.')
          return
        end

        # From dates where number of !cases.zero?
        positive_cases_figures = country['timeline']['cases'].values.reject(&:zero?)
        dates = country['timeline']['cases'].reject { |_k, v| v.zero? }.keys
        data = []

        # Improve this later, like everything else.
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
          y_range = AsciiCharts::Cartesian.new(data, bar: true, hide_zero: true).y_range

          last_two_y = y_range.last 2
          y_interval = last_two_y.last - last_two_y.first

          scale("Scale on Y: #{y_interval}:#{(y_interval / last_two_y.last.to_f * positive_cases_figures.last).round(2) / y_interval}")

          puts 'Experimental feature, please report issues.'

          AsciiCharts::Cartesian.new(data, bar: true, hide_zero: true).draw
        end
      end

      def eu_aggregate(eu_data)
        aggregated_table(eu_data, 'The EU', Kovid::Request::EU_ISOS, '🇪🇺')
      end

      def europe_aggregate(europe_data)
        aggregated_table(europe_data, 'Europe', Kovid::Request::EUROPE_ISOS, '🏰')
      end

      def africa_aggregate(africa_data)
        aggregated_table(africa_data, 'Africa',
                         Kovid::Request::AFRICA_ISOS, '🌍')
      end

      def south_america_aggregate(south_america_data)
        aggregated_table(south_america_data,
                         'South America',
                         Kovid::Request::SOUTH_AMERICA_ISOS, '🌎')
      end

      def asia_aggregate(asia_data)
        aggregated_table(asia_data, 'Asia', Kovid::Request::ASIA_ISOS, '🌏')
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
        title = if emoji.codepoints.size > 1
                  emoji + 8203.chr(Encoding::UTF_8) + \
                    " Aggregated Data on #{continent} (#{iso.size} States)".upcase
                else
                  emoji + \
                    " Aggregated Data on #{continent} (#{iso.size} States)".upcase
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
    end
  end
end
