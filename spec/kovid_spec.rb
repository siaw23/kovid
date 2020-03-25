# frozen_string_literal: true

RSpec.describe Kovid do
  it 'has a version number' do
    expect(Kovid::VERSION).not_to be nil
  end

  describe 'country(name)' do
    let(:country) { 'ghana' }
    let(:no_country) { 'wonderland' }
    it 'returns table with country data' do
      table = Kovid.country(country)

      expect(table.title).to eq('GHANA')
    end

    it 'raise a JSON::ParseError when country specified has no reported case' do
      table = Kovid.country(no_country)
      good_news = "Wrong spelling of location/API has no info on #{no_country.upcase} at the moment."

      expect(table.rows.first.cells.first.value).to eq(good_news)
    end
  end

  describe 'country_full(name)' do
    let(:country) { 'italy' }
    let(:no_country) { 'wonderland' }

    it 'returns table with country data' do
      table = Kovid.country_full(country)

      expect(table.title).to include('ITALY')
    end

    it 'raise a JSON::ParseError when country specified has no reported case' do
      table = Kovid.country_full(no_country)
      good_news = "Wrong spelling of location/API has no info on #{no_country.upcase} at the moment."

      expect(table.rows.first.cells.first.value).to eq(good_news)
    end
  end

  describe 'country_comparison(names_array)' do
    let(:country) { %w[ghana poland] }
    it 'returns table with country data' do
      table = Kovid.country_comparison(country)

      expect(table.headings.first.cells.last.value).to include('Recovered')
      expect(table.headings.first.cells.first.value).to include('Country')
    end
  end

  describe 'country_comparison_full(names_array)' do
    let(:country) { %w[ghana poland] }
    it 'returns table with country data' do
      table = Kovid.country_comparison_full(country)

      expect(table.headings.first.cells.first.value).to include('Country')
      expect(table.headings.first.cells.last.value).to include('Cases/Million')
    end
  end

  describe 'cases' do
    it 'returns summary of cases' do
      table = Kovid.cases

      expect(table.headings.first.cells.first.value).to include('Cases')
      expect(table.headings.first.cells.last.value).to include('Recovered')
    end
  end
end
