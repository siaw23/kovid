# frozen_string_literal: true

RSpec.describe Kovid do
  it 'has a version number' do
    expect(Kovid::VERSION).not_to be nil
  end

  describe 'country(name)' do
    let(:country) { 'ghana' }
    let(:inexistent_country) { 'wonderland' }
    it 'returns table with country data' do
      table = Kovid.country(country)

      expect(table.title).to include('GHANA')
    end

    it 'outputs message informing of wrong spelling or no reported case.' do
      table = Kovid.country(inexistent_country)
      not_found = "Wrong spelling/No reported cases on #{inexistent_country.upcase}."

      expect(table.rows.first.cells.first.value).to eq(not_found)
    end
  end

  describe 'country_full(name)' do
    let(:country) { 'italy' }
    let(:inexistent_country) { 'wonderland' }

    it 'returns table with country data' do
      table = Kovid.country_full(country)

      expect(table.title).to include('ITALY')
    end

    it 'outputs message informing of wrong spelling or no reported case.' do
      table = Kovid.country_full(inexistent_country)
      not_found = "Wrong spelling/No reported cases on #{inexistent_country.upcase}."

      expect(table.rows.first.cells.first.value).to eq(not_found)
    end
  end

  describe 'country_comparison(names_array)' do
    let(:country) { %w[ghana poland] }
    it 'returns table with country data' do
      table = Kovid.country_comparison(country)

      expect(table.headings.first.cells.last.value).to include('Deaths Today')
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
      expect(table.headings.first.cells.last.value).to include('Deaths Today')
    end
  end

  describe 'eu_aggregate' do
    it 'returns collated data on the EU' do
      table = Kovid.eu_aggregate

      expect(table.headings.first.cells.first.value).to include('Cases')
      expect(table.headings.first.cells.last.value).to include('Critical')
    end
  end

  describe 'state' do
    it 'returns a US state data' do
      table = Kovid.state('michigan')

      expect(table.headings.first.cells.first.value).to include('Cases')
      expect(table.headings.first.cells.last.value).to include('Active')
    end
  end

  describe 'history' do
    it 'returns history of given location' do
      table = Kovid.history('ghana', '7')

      expect(table.headings.first.cells.first.value).to include('Date')
      expect(table.headings.first.cells.last.value).to include('Deaths')
    end
  end
end
