# frozen_string_literal: true

require_relative 'request'

module Kovid
  class Nineteen
    class << self
      def whatis
        puts 'Coronavirus disease (COVID-19) is an infectious disease caused by a new virus.'
      end

      def country(name)
        puts Kovid::Request.by_country(name)
      end

      def country_full(name)
        puts Kovid::Request.by_country_full(name)
      end

      def country_comparison(name)
        puts Kovid::Request.by_country_comparison(name)
      end

      def country_comparison_full(name)
        puts Kovid::Request.by_country_comparison_full(name)
      end

      def cases
        puts Kovid::Request.cases
      end
    end
  end
end
