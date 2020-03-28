# frozen_string_literal: true

require 'json'
require_relative 'tablelize'
require_relative 'cache'
require_relative 'uri_builder'

module Kovid
  class Request
    COUNTRIES_PATH = UriBuilder.new('/countries').url
    STATES_URL = UriBuilder.new('/states').url
    EU_ISOS = %w[AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT LU LV MT NL PL PT RO SE SI SK].freeze
    AFRICA_ISOS = %w[DZ AO BJ BW BF BI CM CV CF TD KM CD CG CI DJ EG GQ ER SZ ET GA GM GH GN GW KE LS LR LY MG MW ML MR MU MA MZ NA NE NG RW ST SN SC SL SO ZA SS SD TZ TG TN UG ZM ZW EH].freeze
    SERVER_DOWN = 'Server overwhelmed. Please try again in a moment.'

    class << self
      def eu_aggregate
        countries_array = JSON.parse(Typhoeus.get(UriBuilder.new('/countries').url, cache_ttl: 900).response_body)

        eu_array = countries_array.select do |hash|
          EU_ISOS.include?(hash['countryInfo']['iso2'])
        end

        head, *tail = eu_array
        eu_data = head.merge(*tail) do |key, left, right|
          left ||= 0
          right ||= 0

          left + right unless %w[country countryInfo].include?(key)
        end.compact

        Kovid::Tablelize.eu_aggregate(eu_data)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def africa_aggregate
        countries_array = JSON.parse(Typhoeus.get(UriBuilder.new('/countries').url, cache_ttl: 900).response_body)

        africa_arry = countries_array.select do |hash|
          AFRICA_ISOS.include?(hash['countryInfo']['iso2'])
        end

        head, *tail = africa_arry
        africa_data = head.merge(*tail) do |key, left, right|
          left ||= 0
          right ||= 0

          left + right unless %w[country countryInfo].include?(key)
        end.compact

        Kovid::Tablelize.africa_aggregate(africa_data)
      rescue JSON::ParserError
        puts SERVER_DOWN
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

      def state(state)
        response = fetch_state(state)

        Kovid::Tablelize.full_state_table(response)
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
        array = []

        list.each do |state|
          array << JSON.parse(Typhoeus.get(COUNTRIES_PATH + "/#{state}", cache_ttl: 900).response_body)
        end
      end

      def fetch_country(country_name)
        country_url = COUNTRIES_PATH + "/#{country_name}"

        JSON.parse(Typhoeus.get(country_url, cache_ttl: 900).response_body)
      end

      def fetch_state(state)
        states_array = JSON.parse(Typhoeus.get(STATES_URL, cache_ttl: 900).response_body)

        states_array.select { |state_name| state_name['state'] == capitalize_words(state) }.first
      end
    end
  end
end
