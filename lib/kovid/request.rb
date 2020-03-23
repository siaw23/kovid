# frozen_string_literal: true

require 'json'
require_relative 'tablelize'
require_relative 'cache'

module Kovid
  class Request
    BASE_URL = 'https://corona.lmao.ninja'

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
        path = '/all'
        fetch_url = BASE_URL + path

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 900).response_body)

        Kovid::Tablelize.cases(response)
      end

      def history(country)
        path = '/historical'
        fetch_url = BASE_URL + path + "/#{country}"

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 900).response_body)
        Kovid::Tablelize.history(response)
      end

      private

      def no_case_in(country)
        rows = [["Thankfully, there are no reported cases in #{country.capitalize}!"]]
        Terminal::Table.new headings: [country.capitalize.to_s], rows: rows
      end

      def fetch_countries(list)
        array = []

        list.each do |country|
          path = "/countries/#{country}"
          fetch_url = BASE_URL + path

          array << JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 900).response_body)
        end

        array = array.sort_by { |json| -json['cases'] }
      end

      def fetch_country(country_name)
        path = "/countries/#{country_name}"
        fetch_url = BASE_URL + path

        JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 900).response_body)
      end

      def fetch_state(state)
        path = '/states'
        fetch_url = BASE_URL + path

        states_array = JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 900).response_body)

        states_array.select { |state_name| state_name['state'] == state.split.map(&:capitalize).join(' ') }.first
      end
    end
  end
end
