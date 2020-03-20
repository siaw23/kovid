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
    end
  end
end
