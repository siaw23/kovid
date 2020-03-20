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
        path = "/countries/#{name}"
        fetch_url = BASE_URL + path

        binding.pry

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        Kovid::Tablelize.country_table(response)
      end

      def by_country_full(name)
        path = "/countries/#{name}"
        fetch_url = BASE_URL + path

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        Kovid::Tablelize.full_country_table(response)
      end

    end
  end
end
