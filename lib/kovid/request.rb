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
        fetch_url = build_uri(path: "/countries/#{name}")

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        Kovid::Tablelize.country_table(response)
      end

      def by_country_full(name)
        fetch_url = build_uri(path: "/countries/#{name}")

        response ||= JSON.parse(Typhoeus.get(fetch_url.to_s, cache_ttl: 3600).response_body)
        Kovid::Tablelize.full_country_table(response)
      end

      private

      def build_uri(opts = {})
        host = 'www.corona.lmao.ninja'

        URI::HTTPS.build(host: host, path: opts[:path]).to_s if opts.key?(:path)
      end
    end
  end
end
