# frozen_string_literal: true

require 'kovid/version'
require 'kovid/request'

module Kovid
  require 'kovid/helpers'

  module_function

  def eu_aggregate
    Kovid::Request.eu_aggregate
  end

  def europe_aggregate
    Kovid::Request.europe_aggregate
  end

  def africa_aggregate
    Kovid::Request.africa_aggregate
  end

  def south_america_aggregate
    Kovid::Request.south_america_aggregate
  end

  def asia_aggregate
    Kovid::Request.asia_aggregate
  end

  def country(name)
    Kovid::Request.by_country(name)
  end

  def country_full(name)
    Kovid::Request.by_country_full(name)
  end

  def province(name)
    Kovid::Request.province(name)
  end

  def provinces(names)
    Kovid::Request.provinces(names)
  end

  def state(state)
    Kovid::Request.state(state)
  end

  def states(states)
    Kovid::Request.states(states)
  end

  def all_us_states
    Kovid::Request.all_us_states
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

  def history(country, days = 30)
    Kovid::Request.history(country, days)
  end

  def history_us_state(state, days = 30)
    Kovid::Request.history_us_state(state, days)
  end

  def histogram(country, date)
    Kovid::Request.histogram(country, date)
  end

  def top(count, options = { location: :countries, incident: :cases })
    Kovid::Request.top(count, options)
  end
end
