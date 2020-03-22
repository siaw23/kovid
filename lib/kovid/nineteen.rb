# frozen_string_literal: true

require_relative 'request'

module Kovid
  class Nineteen
    class << self
      def whatis
        "Coronavirus disease 2019 (COVID-19) is an infectious disease caused by severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2)."
      end

      def country(name)
        Kovid::Request.by_country(name)
      end

      def country_full(name)
        Kovid::Request.by_country_full(name)
      end

      def state(state)
        Kovid::Request.state(state)
      end

      def country_comparison(names_array)
        Kovid::Request.by_country_comparison(names_array)
      end

      def country_comparison_full(names_array)
        Kovid::Request.by_country_comparison_full(names_array)
      end

      def cases
        Kovid::Request.cases
      end
    end
  end
end
