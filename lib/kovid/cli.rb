# frozen_string_literal: true

require 'thor'
require 'kovid'

module Kovid
  class CLI < Thor
    FULL_FLAG = %w[-f --full].freeze

    desc 'eu', 'Returns aggregated data on the EU.'
    def eu
      puts Kovid.eu_aggregate
      data_source
    end

    desc 'check COUNTRY or check "COUNTRY NAME"', 'Returns reported data on provided country. eg: "kovid check "hong kong".'
    method_option :full, aliases: '-f'
    def check(name)
      fetch_country_stats(name)
      data_source
    end

    desc 'country COUNTRY or country "COUNTRY NAME"', 'Returns reported data on provided country. eg: "kovid country "hong kong".'
    method_option :full, aliases: '-f'
    def country(name)
      fetch_country_stats(name)
      data_source
    end

    desc 'state STATE', 'Return reported data on provided state.'
    def state(state)
      puts Kovid.state(state)
      data_source
    end

    desc 'compare COUNTRY COUNTRY', 'Returns full comparison table for given countries. Accepts multiple countries.'
    def compare(*name)
      if FULL_FLAG.include?(name.fetch(-1))
        puts Kovid.country_comparison_full(name[0..-2])
      else
        puts Kovid.country_comparison(name)
      end
      data_source
    end

    desc 'cases', 'Returns total number of cases, deaths and recoveries.'
    def cases
      puts Kovid.cases
      data_source
    end

    desc 'history COUNTRY or history COUNTRY N', 'Return history of incidents of COUNTRY (in the last N days)'
    def history(*params)
      if params.size == 2
        puts Kovid.history(params.first, params.last)
      else
        puts Kovid.history(params.first, nil)
      end
      data_source
    end

    private

    def fetch_country_stats(country)
      if options[:full]
        puts Kovid.country_full(country)
      else
        puts Kovid.country(country)
      end
    end

    def data_source
      source = <<~TEXT
        Sources:
         * JHU CSSE GISand Data
         * https://www.worldometers.info/coronavirus/
      TEXT
      puts source
      puts
    end
  end
end
