# frozen_string_literal: true

require 'kovid/version'
require 'kovid/request'

module Kovid
  class Error < StandardError; end

  module_function

  def eu_aggregate
    Kovid::Request.eu_aggregate
  end

  def country(name)
    Kovid::Request.by_country(name)
  end

  def country_full(name)
    Kovid::Request.by_country_full(name)
  end

  def state(state)
    Kovid::Request.state(state)
  end

  def states(*_states)
    Kovid::Request.states(state)
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

  def history(country, last)
    Kovid::Request.history(country, last)
  end
end
