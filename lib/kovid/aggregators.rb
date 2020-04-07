# frozen_string_literal: true

module Kovid
  module Aggregators
    def eu_aggregate(eu_data)
      aggregated_table(eu_data, 'The EU', Kovid::Request::EU_ISOS, '🇪🇺')
    end

    def europe_aggregate(europe_data)
      aggregated_table(europe_data, 'Europe', Kovid::Request::EUROPE_ISOS, '🏰')
    end

    def africa_aggregate(africa_data)
      aggregated_table(africa_data, 'Africa',
                       Kovid::Request::AFRICA_ISOS, '🌍')
    end

    def south_america_aggregate(south_america_data)
      aggregated_table(south_america_data,
                       'South America',
                       Kovid::Request::SOUTH_AMERICA_ISOS, '🌎')
    end

    def asia_aggregate(asia_data)
      aggregated_table(asia_data, 'Asia', Kovid::Request::ASIA_ISOS, '🌏')
    end
  end
end
