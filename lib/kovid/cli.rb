# frozen_string_literal: true

require 'thor'
require 'kovid'

module Kovid
  # Describes the commands that can be run by the user
  # Descriptions are returned to STDOUT
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'province PROVINCE or province "PROVINCE NAME"',
         'Returns reported data on provided province. ' \
         'eg "kovid check "new brunswick".'
    method_option :full, aliases: '-p'
    def province(name)
      puts Kovid.province(name)
      data_source
    end

    desc 'provinces PROVINCE PROVINCE',
         'Returns full comparison table for the given provinces. ' \
         'Accepts multiple provinces.'
    def provinces(*names)
      puts Kovid.provinces(names)
      data_source
    end

    desc 'check COUNTRY or check "COUNTRY NAME"',
         'Returns reported data on provided country. ' \
         'eg: "kovid check "hong kong".'
    method_option :full, aliases: '-f'
    def check(*name)
      if name.size == 1
        fetch_country_stats(name.pop)
      elsif options[:full]
        puts Kovid.country_comparison_full(name)
      else
        puts Kovid.country_comparison(name)
      end
      data_source
    end
    map country: :check

    desc 'compare COUNTRY COUNTRY', 'Deprecated. Will be removed in v7.0.0'
    def compare(*_name)
      Kovid.info_table("#compare is deprecated and will be removed in v7.0.0. \
         \nPlease do `kovid check COUNTRY COUNTRY ...` instead.")
    end

    desc 'state STATE', 'Return reported data on provided state.'
    def state(state)
      puts Kovid.state(state)
      data_source
    end

    desc 'states STATE STATE or states --all',
         'Returns full comparison table for the given states. ' \
         'Accepts multiple states.'
    method_option :all, aliases: '-a'
    def states(*states)
      if options[:all]
        puts Kovid.all_us_states
      else
        downcased_states = states.map(&:downcase)
        puts Kovid.states(downcased_states)
      end

      data_source
    end

    desc 'world', 'Returns total number of cases, deaths and recoveries.'
    def world
      puts Kovid.cases
      data_source
    end

    desc 'history COUNTRY or history COUNTRY N',
         'Return history of incidents of COUNTRY (in the last N days)'
    def history(*params)
      if params.size == 2
        puts Kovid.history(params.first, params.last)
      else
        puts Kovid.history(params.first, nil)
      end
      data_source
    end

    desc 'eu', 'Returns aggregated data on the EU.'
    def eu
      puts Kovid.eu_aggregate
      data_source
    end

    desc 'europe', 'Returns aggregated data on Europe.'
    def europe
      puts Kovid.europe_aggregate
      data_source
    end

    desc 'africa', 'Returns aggregated data on Africa.'
    def africa
      puts Kovid.africa_aggregate
      data_source
    end

    desc 'sa', 'Returns aggregated data on South America.'
    def sa
      puts Kovid.south_america_aggregate
      data_source
    end

    desc 'asia', 'Returns aggregated data on Asia.'
    def asia
      puts Kovid.asia_aggregate
      data_source
    end

    desc 'version', 'Returns version of kovid'
    def version
      puts Kovid::VERSION
    end

    desc 'histogram COUNTRY M.YY', 'Returns a histogram of incidents.'
    def histogram(country, date = nil)
      if date.nil?
        Kovid.info_table("Please add a month and year in the form 'M.YY'")
      else
        puts Kovid.histogram(country, date)
        data_source
      end
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
        #{Time.now}
        Sources:
         * JHU CSSE GISand Data
         * https://www.worldometers.info/coronavirus/
      TEXT
      puts source
    end
  end
end
