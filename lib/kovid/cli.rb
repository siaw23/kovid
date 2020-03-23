# frozen_string_literal: true

require 'thor'
require 'kovid'

module Kovid
  class CLI < Thor
    FULL_FLAG = %w[-f --full].freeze

    desc 'define', 'Defines COVID-19'
    def define
      puts Kovid::Nineteen.whatis
    end

    desc 'check COUNTRY', 'Returns reported data on provided country'
    method_option :full, aliases: '-f'
    def check(name)
      if options[:full]
        puts Kovid::Nineteen.country_full(name)
      else
        puts Kovid::Nineteen.country(name)
      end
    end

    desc 'state STATE', 'Return reported data on provided state'
    def state(state)
      puts Kovid::Nineteen.state(state)
    end

    desc 'compare COUNTRY COUNTRY', 'Returns full comparison table for given countries. Accepts multiple countries'
    def compare(*name)
      if FULL_FLAG.include?(name.fetch(-1))
        name = name.reverse.drop(1).reverse
        puts Kovid::Nineteen.country_comparison_full(name)
      else
        puts Kovid::Nineteen.country_comparison(name)
      end
    end

    desc 'cases', 'Returns total number of cases, deaths and recoveries'
    def cases
      puts Kovid::Nineteen.cases
    end
  end
end
