# frozen_string_literal: true

require 'thor'
require 'kovid'

module Kovid
  class CLI < Thor
    FULL_FLAG = %w[-f --full].freeze

    desc 'define', 'Defines COVID-19'
    def define
      puts Kovid.whatis
    end

    desc 'check COUNTRY or check "COUNTRY NAME"', 'Returns reported data on provided country. eg: "kovid check "hong kong".'
    method_option :full, aliases: '-f'
    def check(name)
      if options[:full]
        puts Kovid.country_full(name)
      else
        puts Kovid.country(name)
      end
    end
    desc 'country COUNTRY or country "COUNTRY NAME"', 'Returns reported data on provided country. eg: "kovid country "hong kong".'
    alias country check

    desc 'state STATE', 'Return reported data on provided state.'
    def state(state)
      puts Kovid.state(state)
    end

    desc 'compare COUNTRY COUNTRY', 'Returns full comparison table for given countries. Accepts multiple countries.'
    def compare(*name)
      if FULL_FLAG.include?(name.fetch(-1))
        puts Kovid.country_comparison_full(name[0..-2])
      else
        puts Kovid.country_comparison(name)
      end
    end

    desc 'cases', 'Returns total number of cases, deaths and recoveries.'
    def cases
      puts Kovid.cases
    end
  end
end
