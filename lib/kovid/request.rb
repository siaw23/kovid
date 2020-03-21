# frozen_string_literal: true

require 'typhoeus'
require 'json'
require_relative 'tablelize'

module Kovid
  class Request
    BASE_URL = 'https://corona.lmao.ninja'

    class << self
      require 'pry'
      def by_country(name)
        # path = "/countries/#{name}"
        # fetch_url = BASE_URL + path

        # binding.pry
        # response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        # Kovid::Tablelize.country_table(response)

        begin
          path = "/countries/#{name}"
          fetch_url = BASE_URL + path

          response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
          Kovid::Tablelize.country_table(response)

        rescue JSON::ParserError
          rows = []
          rows << ["Thankfully there are no reported cases in #{name.capitalize}!"]
          table = Terminal::Table.new :headings => ["#{name}",], :rows => rows
          puts table
        end
      end

      def by_country_full(name)
        path = "/countries/#{name}"
        fetch_url = BASE_URL + path

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        Kovid::Tablelize.full_country_table(response)
      end

      def by_country_comparison(list)
        array = []

        list.each do |country|
          path = "/countries/#{country}"
          fetch_url = BASE_URL + path

          array << JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        end

        Kovid::Tablelize.compare_countries_table(array)
      end

      def by_country_comparison_full(list)
        array = []

        list.each do |country|
          path = "/countries/#{country}"
          fetch_url = BASE_URL + path

          array << JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        end

        Kovid::Tablelize.compare_countries_table_full(array)
      end

      def cases
        path = '/all'
        fetch_url = BASE_URL + path

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        Kovid::Tablelize.cases(response)
      end
    end
  end
end
