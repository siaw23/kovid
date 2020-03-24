# frozen_string_literal: true

require 'json'
require_relative 'tablelize'
require_relative 'cache'
require_relative 'uri_builder'

module Kovid
  class Request
    COUNTRIES_PATH = UriBuilder.new('/countries').url

    class << self
      def by_country(country_name)
        response = fetch_country(country_name)

        Kovid::Tablelize.country_table(response)
      rescue JSON::ParserError
        no_case_in(country_name)
      end

      def by_country_full(country_name)
        response = fetch_country(country_name)

        Kovid::Tablelize.full_country_table(response)
      rescue JSON::ParserError
        no_case_in(country_name)
      end

      def state(state)
        response = fetch_state(state)

        Kovid::Tablelize.full_state_table(response)
      end

      def by_country_comparison(list)
        array = fetch_countries(list)
        Kovid::Tablelize.compare_countries_table(array)
      end

      def by_country_comparison_full(list)
        array = fetch_countries(list)
        Kovid::Tablelize.compare_countries_table_full(array)
      end

      def cases
        response ||= JSON.parse(Typhoeus.get(UriBuilder.new('/all').url, cache_ttl: 900).response_body)

        Kovid::Tablelize.cases(response)
      end

      def history(country)
        history_path = UriBuilder.new('/historical').url
        response ||= JSON.parse(Typhoeus.get(history_path + "/#{country}", cache_ttl: 900).response_body)

        Kovid::Tablelize.history(response)
      end

      private

      def no_case_in(country)
        rows = [['No reported cases OR check your spelling!']]
        Terminal::Table.new headings: ["You checked: #{country.capitalize}"], rows: rows
      end

      def fetch_countries(list)
        array = []

        list.each do |country|
          array << JSON.parse(Typhoeus.get(COUNTRIES_PATH + "/#{country}", cache_ttl: 900).response_body)
        end

        array = array.sort_by { |json| -json['cases'] }
      end

      def fetch_country(country_name)
        url = COUNTRIES_PATH + "/#{country_name}"

        JSON.parse(Typhoeus.get(url, cache_ttl: 900).response_body)
      end

      def fetch_state(state)
        url = UriBuilder.new('/states').url

        states_array = JSON.parse(Typhoeus.get(url, cache_ttl: 900).response_body)

        states_array.select { |state_name| state_name['state'] == capitalize_words(state) }.first
      end

      private

      def capitalize_words(string)
        string.split.map(&:capitalize).join(' ')
      end
    end
  end
end
