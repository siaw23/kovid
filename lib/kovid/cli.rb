# frozen_string_literal: true

require 'thor'
require 'kovid'

module Kovid
  class CLI < Thor
    desc 'define', 'Defines COVID-19'
    def define
      Kovid::Nineteen.whatis
    end

    desc 'check COUNTRY', 'Returns reported data on provided country'
    method_option :full, aliases: '-f'
    def check(name)
      if options[:full]
        Kovid::Nineteen.country_full(name)
      else
        Kovid::Nineteen.country(name)
      end
    end

    desc 'compare COUNTRY COUNTRY', 'Returns full comparison table for given countries. Accepts multiple countries'
    def compare(*name)
      if name[-1] == '-f' || name[-1] == '--full'
        name = name.reverse.drop(1).reverse
        Kovid::Nineteen.country_comparison_full(name)
      else
        Kovid::Nineteen.country_comparison(name)
      end
    end

    desc 'cases', 'Returns total number of cases, deaths and recoveries'
    def cases
      Kovid::Nineteen.cases
    end
  end
end
