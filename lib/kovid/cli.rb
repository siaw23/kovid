# frozen_string_literal: true

require 'thor'
require 'kovid'

module Kovid
  class CLI < Thor
    desc 'whatis', 'Defines COVID-19'
    def whatis
      Kovid::Nineteen.whatis
    end

    desc 'check', 'Returns data on country'
    method_option :full, aliases: '-f'
    def check(name)
      if options[:full]
        Kovid::Nineteen.country_full(name)
      else
        Kovid::Nineteen.country(name)
      end
    end

    desc 'compare', 'Returns full comparison table for given countries'
    def compare(*name)
      if name[-1] == "-f" || name[-1] == "--full"
        name = name.reverse.drop(1).reverse

        Kovid::Nineteen.country_comparison_full(name)
      else
        Kovid::Nineteen.country_comparison(name)
      end
    end
  end
end
