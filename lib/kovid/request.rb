# frozen_string_literal: true

require 'json'
require_relative 'tablelize'
require_relative 'cache'
require_relative 'uri_builder'

module Kovid
  class Request
    COUNTRIES_PATH = UriBuilder.new('/countries').url
    STATES_URL = UriBuilder.new('/states').url
    JHUCSSE_URL = UriBuilder.new('/v2/jhucsse').url

    SERVER_DOWN = 'Server overwhelmed. Please try again in a moment.'

    EU_ISOS = %w[AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT LU LV MT NL PL PT RO SE SI SK].freeze
    EUROPE_ISOS = EU_ISOS + %w[GB IS NO CH MC AD SM VA BA RS ME MK AL BY UA RU MD]
    AFRICA_ISOS = %w[DZ AO BJ BW BF BI CM CV CF TD KM CD CG CI DJ EG GQ ER SZ ET GA GM GH GN GW KE LS LR LY MG MW ML MR MU MA MZ NA NE NG RW ST SN SC SL SO ZA SS SD TZ TG TN UG ZM ZW EH].freeze
    SOUTH_AMERICA_ISOS = ['AR' 'BO', 'BV', 'BR', 'CL', 'CO', 'EC', 'FK', 'GF', 'GY', 'PY', 'PE', 'GS', 'SR', 'UY', 'VE'].freeze
    ASIA_ISOS = %w[AE AF AM AZ BD BH BN BT CC CN CX GE HK ID IL IN IQ IR JO JP KG KH KP KR KW KZ LA LB LK MM MN MO MY NP OM PH PK PS QA SA SG SY TH TJ TL TM TR TW UZ VN YE].freeze

    class << self
      def eu_aggregate
        eu_proc = proc do |data|
          Kovid::Tablelize.eu_aggregate(data)
        end

        aggregator(EU_ISOS, eu_proc)
      end

      def europe_aggregate
        europe_proc = proc do |data|
          Kovid::Tablelize.europe_aggregate(data)
        end

        aggregator(EUROPE_ISOS, europe_proc)
      end

      def africa_aggregate
        africa_proc = proc do |data|
          Kovid::Tablelize.africa_aggregate(data)
        end

        aggregator(AFRICA_ISOS, africa_proc)
      end

      def south_america_aggregate
        south_america_proc = proc do |data|
          Kovid::Tablelize.south_america_aggregate(data)
        end

        aggregator(SOUTH_AMERICA_ISOS, south_america_proc)
      end

      def asia_aggregate
        asia_proc = proc do |data|
          Kovid::Tablelize.asia_aggregate(data)
        end

        aggregator(ASIA_ISOS, asia_proc)
      end

      def by_country(country_name)
        response = fetch_country(country_name)

        if response.values.first.include?('not found')
          not_found(country_name)
        else
          Kovid::Tablelize.country_table(response)
        end
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def by_country_full(country_name)
        response = fetch_country(country_name)

        if response.values.first.include?('not found')
          not_found(country_name)
        else
          Kovid::Tablelize.full_country_table(response)
        end
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def province(province)
        response = fetch_province(province)
        if response.nil?
          not_found(province)
        else
          Kovid::Tablelize.full_province_table(response)
        end
      end

      def provinces(names)
        array = fetch_provinces(names)

        Kovid::Tablelize.compare_provinces(array)
      end

      def state(state)
        response = fetch_state(state)
        if response.nil?
          not_found(state)
        else
          Kovid::Tablelize.full_state_table(response)
        end
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def states(list)
        array = fetch_states(list)

        Kovid::Tablelize.compare_us_states(array)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def by_country_comparison(list)
        array = fetch_countries(list)
        Kovid::Tablelize.compare_countries_table(array)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def by_country_comparison_full(list)
        array = fetch_countries(list)
        Kovid::Tablelize.compare_countries_table_full(array)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def cases
        response = JSON.parse(Typhoeus.get(UriBuilder.new('/all').url, cache_ttl: 900).response_body)

        Kovid::Tablelize.cases(response)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def history(country, last)
        history_path = UriBuilder.new('/v2/historical').url
        response = JSON.parse(Typhoeus.get(history_path + "/#{country}", cache_ttl: 900).response_body)

        Kovid::Tablelize.history(response, last)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def histogram(country, date)
        history_path = UriBuilder.new('/v2/historical').url
        response = JSON.parse(Typhoeus.get(history_path + "/#{country}", cache_ttl: 900).response_body)

        Kovid::Tablelize.histogram(response, date)
      end

      def capitalize_words(string)
        string.split.map(&:capitalize).join(' ')
      end

      private

      def not_found(country)
        rows = [["Wrong spelling/No reported cases on #{country.upcase}."]]
        Terminal::Table.new title: "You checked: #{country.upcase}", rows: rows
      end

      def fetch_countries(list)
        array = []

        list.each do |country|
          array << JSON.parse(Typhoeus.get(COUNTRIES_PATH + "/#{country}", cache_ttl: 900).response_body)
        end

        array = array.sort_by { |json| -json['cases'] }
      end

      def fetch_states(list)
        states_json = JSON.parse(Typhoeus.get(STATES_URL, cache_ttl: 900).response_body)
        states_array = []

        states_json.select do |state|
          states_array << state if list.include?(state['state'].downcase)
        end
      end

      def fetch_country(country_name)
        country_url = COUNTRIES_PATH + "/#{country_name}"

        JSON.parse(Typhoeus.get(country_url, cache_ttl: 900).response_body)
      end

      def fetch_jhucsse
        JSON.parse(Typhoeus.get(JHUCSSE_URL, cache_ttl: 900).response_body)
      end

      def fetch_province(province)
        response = fetch_jhucsse
        response.select { |datum| datum['province'] == capitalize_words(province) }.first
      end

      def fetch_provinces(provinces)
        provinces.map!(&method(:capitalize_words))
        response = fetch_jhucsse
        response.select { |datum| provinces.include? datum['province'] }
      end

      def fetch_state(state)
        states_array = JSON.parse(Typhoeus.get(STATES_URL, cache_ttl: 900).response_body)

        states_array.select { |state_name| state_name['state'] == capitalize_words(state) }.first
      end

      def aggregator(isos, meth)
        countries_array = JSON.parse(Typhoeus.get(UriBuilder.new('/countries').url, cache_ttl: 900).response_body)

        country_array = countries_array.select do |hash|
          isos.include?(hash['countryInfo']['iso2'])
        end

        data = country_array.inject do |base, other|
          base.merge(other) do |key, left, right|
            left ||= 0
            right ||= 0

            left + right unless %w[country countryInfo].include?(key)
          end
        end.compact

        meth === data
      rescue JSON::ParserError
        puts SERVER_DOWN
      end
    end
  end
end
