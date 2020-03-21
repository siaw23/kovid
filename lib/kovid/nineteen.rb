# frozen_string_literal: true

require_relative 'request'

module Kovid
  class Nineteen
    class << self
      def whatis
        definition = <<-TEXT
        Coronavirus disease 2019 (COVID-19) is an infectious disease caused by severe acute
        respiratory syndrome coronavirus 2 (SARS-CoV-2).
        The disease was first identified in 2019 in Wuhan, China, and has since spread globally,
        resulting in the 2019–20 coronavirus pandemic.
        TEXT
        puts definition
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
