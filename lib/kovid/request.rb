# frozen_string_literal: true

require 'json'
require 'erb'
require_relative 'tablelize'
require_relative 'cache'
require_relative 'uri_builder'

module Kovid
  class Request
    COUNTRIES_PATH      = UriBuilder.new('/v2/countries').url
    STATES_URL          = UriBuilder.new('/v2/states').url
    JHUCSSE_URL         = UriBuilder.new('/v2/jhucsse').url
    HISTORICAL_URL      = UriBuilder.new('/v2/historical').url
    HISTORICAL_US_URL   = UriBuilder.new('/v2/historical/usacounties').url

    SERVER_DOWN         = 'Server overwhelmed. Please try again in a moment.'

    EU_ISOS             = %w[AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT \
                             LU LV MT NL PL PT RO SE SI SK].freeze
    EUROPE_ISOS         = EU_ISOS + %w[GB IS NO CH MC AD SM VA BA RS ME MK AL \
                                       BY UA RU MD].freeze
    AFRICA_ISOS         = %w[DZ AO BJ BW BF BI CM CV CF TD KM CD CG CI DJ EG \
                             GQ ER SZ ET GA GM GH GN GW KE LS LR LY MG MW ML \
                             MR MU MA MZ NA NE NG RW ST SN SC SL SO ZA SS SD \
                             TZ TG TN UG ZM ZW EH].freeze
    SOUTH_AMERICA_ISOS  = %w[AR BO BV BR CL CO EC FK GF GY PY PE GS SR \
                             UY VE].freeze
    ASIA_ISOS           = %w[AE AF AM AZ BD BH BN BT CC CN CX GE HK ID IL IN \
                             IQ IR JO JP KG KH KP KR KW KZ LA LB LK MM MN MO \
                             MY NP OM PH PK PS QA SA SG SY TH TJ TL TM TR TW \
                             UZ VN YE].freeze

    class << self
      def eu_aggregate
        eu_proc = proc do |data|
          Kovid::Tablelize.eu_aggregate(data)
        end

        aggregator(EU_ISOS, eu_proc)
      end

      def europe_aggregate
        europe_proc = proc do |data|
          Kovid::Tablelize.europe_aggregate(data)
        end

        aggregator(EUROPE_ISOS, europe_proc)
      end

      def africa_aggregate
        africa_proc = proc do |data|
          Kovid::Tablelize.africa_aggregate(data)
        end

        aggregator(AFRICA_ISOS, africa_proc)
      end

      def south_america_aggregate
        south_america_proc = proc do |data|
          Kovid::Tablelize.south_america_aggregate(data)
        end

        aggregator(SOUTH_AMERICA_ISOS, south_america_proc)
      end

      def asia_aggregate
        asia_proc = proc do |data|
          Kovid::Tablelize.asia_aggregate(data)
        end

        aggregator(ASIA_ISOS, asia_proc)
      end

      def by_country(country_name)
        response = fetch_country(country_name)

        if response.key?('message')
          not_found(country_name)
        else
          Kovid::Tablelize.country_table(response)
        end
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def by_country_full(country_name)
        response = fetch_country(country_name)

        if response.key?('message')
          not_found(country_name)
        else
          Kovid::Tablelize.full_country_table(response)
        end
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def province(province)
        response = fetch_province(province)
        if response.nil?
          not_found(province)
        else
          Kovid::Tablelize.full_province_table(response)
        end
      end

      def provinces(names)
        array = fetch_provinces(names)

        Kovid::Tablelize.compare_provinces(array)
      end

      def state(state)
        response = fetch_state(Kovid.lookup_us_state(state))

        if response.nil?
          not_found(state)
        else
          Kovid::Tablelize.full_state_table(response)
        end
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def states(states)
        compared_states = fetch_compared_states(states)
        Kovid::Tablelize.compare_us_states(compared_states)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def all_us_states
        state_data = fetch_state_data
        Kovid::Tablelize.compare_us_states(state_data)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def by_country_comparison(list)
        array = fetch_countries(list)
        Kovid::Tablelize.compare_countries_table(array)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def by_country_comparison_full(list)
        array = fetch_countries(list)
        Kovid::Tablelize.compare_countries_table_full(array)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def cases
        response = JSON.parse(
          Typhoeus.get(UriBuilder.new('/v2/all').url, cache_ttl: 900).response_body
        )

        Kovid::Tablelize.cases(response)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def history(country, days)
        response = fetch_history(country)

        if response.key?('message')
          not_found(country) do |c|
            "Could not find cases for #{c}.\nIf searching United States, add --usa option"
          end
        else
          Kovid::Tablelize.history(response, days)
        end
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def history_us_state(state, days)
        state    = Kovid.lookup_us_state(state).downcase
        response = fetch_us_history(state)

        if response.respond_to?(:key?) && response.key?('message')
          return not_found(state)
        end

        # API Endpoint returns list of counties for given state, so
        # we aggreage cases for all counties
        # Note: no data for 'Recovered'
        cases  = usacounties_aggregator(response, 'cases')
        deaths = usacounties_aggregator(response, 'deaths')

        response = {
          'state' => state,
          'timeline' => { 'cases' => cases, 'deaths' => deaths }
        }

        Kovid::Tablelize.history_us_state(response, days)
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def histogram(country, date)
        response = JSON.parse(
          Typhoeus.get(
            HISTORICAL_URL + "/#{country}", cache_ttl: 900
          ).response_body
        )

        Kovid::Tablelize.histogram(response, date)
      end

      def top(count, options)
        response = JSON.parse(
          Typhoeus.get(
            top_url(options[:location]) +
            "?sort=#{options[:incident]}",
            cache_ttl: 900
          ).response_body
        )

        Kovid::Tablelize.top(response.first(count),
                             options.merge({ count: count }))
      end

      def capitalize_words(string)
        string.split.map(&:capitalize).join(' ')
      end

      private

      def not_found(location)
        rows = []
        default_warning = "Wrong spelling/No reported cases on #{location.upcase}."

        rows << if block_given?
                  [yield(location)]
                else
                  [default_warning]
                end

        Terminal::Table.new title: "You checked: #{location.upcase}", rows: rows
      end

      def fetch_countries(list)
        list.map do |country|
          JSON.parse(
            Typhoeus.get(
              COUNTRIES_PATH + "/#{country}", cache_ttl: 900
            ).response_body
          )
        end.sort_by { |json| -json['cases'] }
      end

      def fetch_compared_states(submitted_states)
        submitted_states.map! { |s| Kovid.lookup_us_state(s) }

        fetch_state_data.select do |state|
          submitted_states.include?(state['state'])
        end
      end

      def fetch_state_data
        JSON.parse(Typhoeus.get(STATES_URL, cache_ttl: 900).response_body)
      end

      def fetch_country(country_name)
        # TODO: Match ISOs to full country names
        country_name = 'nl' if country_name == 'netherlands'
        country_url = COUNTRIES_PATH + "/#{ERB::Util.url_encode(country_name)}"

        JSON.parse(Typhoeus.get(country_url, cache_ttl: 900).response_body)
      end

      def fetch_jhucsse
        JSON.parse(Typhoeus.get(JHUCSSE_URL, cache_ttl: 900).response_body)
      end

      def fetch_province(province)
        response = fetch_jhucsse
        response.select do |datum|
          datum['province'] == capitalize_words(province)
        end.first
      end

      def fetch_provinces(provinces)
        provinces.map!(&method(:capitalize_words))
        response = fetch_jhucsse
        response.select { |datum| provinces.include? datum['province'] }
      end

      def fetch_state(state)
        states_array = JSON.parse(
          Typhoeus.get(STATES_URL, cache_ttl: 900).response_body
        )

        states_array.select do |state_name|
          state_name['state'] == capitalize_words(state)
        end.first
      end

      def fetch_history(country)
        JSON.parse(
          Typhoeus.get(
            HISTORICAL_URL + "/#{ERB::Util.url_encode(country)}", cache_ttl: 900
          ).response_body
        )
      end

      def fetch_us_history(state)
        JSON.parse(
          Typhoeus.get(
            HISTORICAL_US_URL + "/#{ERB::Util.url_encode(state)}", cache_ttl: 900
          ).response_body
        )
      end

      def aggregator(isos, meth)
        countries_array = JSON.parse(countries_request)
        country_array = countries_array.select do |hash|
          isos.include?(hash['countryInfo']['iso2'])
        end
        data = countries_aggregator(country_array)

        meth === data
      rescue JSON::ParserError
        puts SERVER_DOWN
      end

      def countries_request
        Typhoeus.get(COUNTRIES_PATH, cache_ttl: 900).response_body
      end

      def countries_aggregator(country_array)
        country_array.inject do |base, other|
          base.merge(other) do |key, left, right|
            left  ||= 0
            right ||= 0

            left + right unless %w[country countryInfo].include?(key)
          end
        end.compact
      end

      def usacounties_aggregator(data, key = nil)
        data.inject({}) do |base, other|
          base.merge(other['timeline'][key]) do |_k, l, r|
            l ||= 0
            r ||= 0
            l + r
          end
        end.compact
      end

      def top_url(location)
        location == :countries ? COUNTRIES_PATH : STATES_URL
      end
    end
  end
end
