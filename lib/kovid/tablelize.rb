# frozen_string_literal: true

require 'terminal-table'

module Kovid
  class Tablelize
    def self.country_table(data)
      rows = []
      rows << [data['cases'], data['deaths'], data['recovered']]
      puts Terminal::Table.new(title: data['country'], headings: %w[Cases Deaths Recovered], rows: rows)
    end

    def self.full_country_table(data)
      headings = [
        'Cases',
        'Deaths',
        'Recovered',
        'Cases Today',
        'Deaths Today',
        'Critical',
        'Cases/Million'
      ]

      rows = []
      rows << [
        data['cases'],
        data['deaths'],
        data['recovered'],
        data['todayCases'],
        data['todayDeaths'],
        data['critical'],
        data['casesPerOneMillion']
      ]
      puts Terminal::Table.new(title: data['country'],
                               headings: headings,
                               rows: rows)
    end
  end
end
