# frozen_string_literal: true

module Kovid
  module Constants
    CASES_DEATHS_RECOVERED = [
      'Cases'.paint_white,
      'Deaths'.paint_red,
      'Recovered'.paint_green
    ].freeze

    CASES_DEATHS_RECOVERED_CTODAY_DTODAY = [
      'Cases'.paint_white,
      'Cases Today'.paint_white,
      'Deaths'.paint_red,
      'Deaths Today'.paint_red,
      'Recovered'.paint_green
    ].freeze

    DATE_CASES_DEATHS_RECOVERED = [
      'Date'.paint_white,
      'Cases'.paint_white,
      'Deaths'.paint_red,
      'Recovered'.paint_green
    ].freeze

    DATE_CASES_DEATHS = [
      'Date'.paint_white,
      'Cases'.paint_white,
      'Deaths'.paint_red
    ].freeze

    CONTINENTAL_AGGREGATE_HEADINGS = [
      'Cases'.paint_white,
      'Cases Today'.paint_white,
      'Deaths'.paint_red,
      'Deaths Today'.paint_red,
      'Recovered'.paint_green,
      'Active'.paint_yellow,
      'Critical'.paint_red
    ].freeze

    COMPARE_COUNTRY_TABLE_FULL = [
      'Country'.paint_white,
      'Cases'.paint_white,
      'Deaths'.paint_red,
      'Recovered'.paint_green,
      'Cases Today'.paint_white,
      'Deaths Today'.paint_red,
      'Critical'.paint_yellow,
      'Cases/Million'.paint_white
    ].freeze

    COMPARE_COUNTRIES_TABLE_HEADINGS = [
      'Country'.paint_white,
      'Cases'.paint_white,
      'Cases Today'.paint_white,
      'Deaths'.paint_red,
      'Deaths Today'.paint_red,
      'Recovered'.paint_green
    ].freeze

    FULL_COUNTRY_TABLE_HEADINGS = [
      'Cases'.paint_white,
      'Deaths'.paint_red,
      'Recovered'.paint_green,
      'Cases Today'.paint_white,
      'Deaths Today'.paint_red,
      'Critical'.paint_yellow,
      'Cases/Million'.paint_white
    ].freeze

    FULL_PROVINCE_TABLE_HEADINGS = [
      'Confirmed'.paint_white,
      'Deaths'.paint_red,
      'Recovered'.paint_green
    ].freeze

    FULL_STATE_TABLE_HEADINGS = [
      'Cases'.paint_white,
      'Cases Today'.paint_white,
      'Deaths'.paint_red,
      'Deaths Today'.paint_red,
      'Active'.paint_yellow
    ].freeze

    COMPARE_STATES_HEADINGS = [
      'State'.paint_white,
      'Cases'.paint_white,
      'Cases Today'.paint_white,
      'Deaths'.paint_red,
      'Deaths Today'.paint_red,
      'Active'.paint_yellow
    ].freeze

    COMPARE_PROVINCES_HEADINGS = [
      'Province'.paint_white,
      'Confirmed'.paint_white,
      'Deaths'.paint_red,
      'Recovered'.paint_green
    ].freeze

    FOOTER_LINE_THREE_COLUMNS = [
      '------------',
      '------------',
      '------------'
    ].freeze

    FOOTER_LINE_FOUR_COLUMNS = [
      '------------',
      '------------',
      '------------',
      '------------'
    ].freeze

    COUNTRY_LETTERS = 'A'.upto('Z').with_index(127_462).to_h.freeze

    RIGHT_ALIGN_COLUMNS = {
      compare_country_table_full: [1, 2, 3, 4, 5, 6, 7],
      compare_country_table: [1, 2, 3, 4, 5],
      compare_us_states: [1, 2, 3, 4, 5],
      compare_provinces: [1, 2, 3]
    }.freeze
  end
end
