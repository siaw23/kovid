# frozen_string_literal: true

RSpec.describe Kovid do
  it 'has a version number' do
    expect(Kovid::VERSION).not_to be nil
  end

  describe 'province(name)' do
    let(:province) { 'ontario' }
    let(:inexistent_province) { 'wonderland' }
    it 'returns table with province data' do
      table = Kovid.province(province)

      expect(table.title).to include('ONTARIO')
    end

    it 'outputs message informing of wrong spelling or no reported case.' do
      table = Kovid.province(inexistent_province)

      expect(table.rows.first.cells.first.value).to eq(
        "Wrong spelling/No reported cases on #{inexistent_province.upcase}."
      )
    end
  end

  describe 'provinces(names)' do
    let(:provinces) { %w[ontario manitoba] }

    it 'returns table with provinces data' do
      table = Kovid.provinces(provinces)

      first_columns = table.rows.map { |row| row.cells.first.value }

      expect(first_columns).to include('MANITOBA').and include('ONTARIO')
    end
  end

  describe 'country(name)' do
    let(:country) { 'ghana' }
    let(:inexistent_iso) { 'diamond princess' }
    let(:inexistent_country) { 'wonderland' }
    it 'returns table with country data' do
      table = Kovid.country(country)

      expect(table.title).to include('GHANA')
    end

    it 'returns table title with inexistent iso' do
      table = Kovid.country(inexistent_iso)

      expect(table.title).to eq('DIAMOND PRINCESS')
    end

    it 'outputs message informing of wrong spelling or no reported case.' do
      table = Kovid.country(inexistent_country)

      expect(table.rows.first.cells.first.value).to eq(
        "Wrong spelling/No reported cases on #{inexistent_country.upcase}."
      )
    end
  end

  describe 'country_full(name)' do
    let(:country) { 'italy' }
    let(:inexistent_iso) { 'diamond princess' }
    let(:inexistent_country) { 'wonderland' }

    it 'returns table with country data' do
      table = Kovid.country_full(country)

      expect(table.title).to include('ITALY')
    end

    it 'returns table title with inexistent iso' do
      table = Kovid.country(inexistent_iso)

      expect(table.title).to eq('DIAMOND PRINCESS')
    end

    it 'outputs message informing of wrong spelling or no reported case.' do
      table = Kovid.country_full(inexistent_country)

      expect(table.rows.first.cells.first.value).to eq(
        "Wrong spelling/No reported cases on #{inexistent_country.upcase}."
      )
    end
  end

  describe 'country_comparison(names_array)' do
    let(:country) { %w[ghana poland] }
    it 'returns table with country data' do
      table = Kovid.country_comparison(country)

      expect(table.headings.first.cells.last.value).to include('Tests')
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
      expect(table.headings.first.cells.last.value).to include('Tests')
    end

    it 'accepts US state abbreviations' do
      expect(Kovid.state('michigan').title).to eq Kovid.state('mi').title
      expect(Kovid.state('Alabama').title).to eq Kovid.state('AL').title
      expect(Kovid.state('Maine').title).to eq Kovid.state('Me').title
    end

    it 'outputs message informing of wrong spelling or no reported case.' do
      expect(Kovid.state('Mediocristan').title).to eq('You checked: MEDIOCRISTAN')
    end
  end

  describe 'states' do
    let(:us_states) { %w[AK CA NY VA] }
    it 'returns table with state data' do
      table = Kovid.states(us_states)
      expect(table.rows.size).to eq(4)
    end
  end

  describe 'all_us_states' do
    before do
      allow(Kovid::Request).to receive(:all_us_states)
    end

    it 'calls all_us_states on Kovid::Request' do
      Kovid.all_us_states

      expect(Kovid::Request).to have_received(:all_us_states)
    end
  end

  describe 'history' do
    it 'returns history of given country' do
      table = Kovid.history('ghana', '7')
      expect(table.headings.first.cells.first.value).to include('Date')
      expect(table.headings.first.cells.last.value).to include('Recovered')
    end

    it 'outputs message informing no reported case.' do
      table = Kovid.history('Extremistan')

      expect(table.rows.first.cells.first.value).to start_with(
        'Could not find cases for Extremistan'
      )
    end

    it 'returns history of given state' do
      table = Kovid.history_us_state('va', '14')
      expect(table.headings.first.cells.first.value).to include('Date')
      expect(table.headings.first.cells.last.value).to include('Deaths')
      expect(table.title).to eq('VIRGINIA')
    end

    it 'returns correct amount of records' do
      table1 = Kovid.history_us_state('ny', '7')
      expect(table1.rows.size).to eq(7)

      table2 = Kovid.history_us_state('nj', 5)
      expect(table2.rows.size).to eq(5)
    end

    it 'adds footers rows when reocrds greater than 10' do
      table = Kovid.history_us_state('md', '22')
      expect(table.rows.size).to eq(24)
    end

    it 'defaults to days (30) for history' do
      table = Kovid.history_us_state('md')
      expect(table.title).to eq('MARYLAND')

      # Footer rows add two additional rows
      expect(table.rows.size).to eq(32)
    end
  end

  describe 'top' do
    it 'defaults to top countries in cases' do
      table = Kovid.top(5)
      expect(table.headings.first.cells.first.value).to include('Country')
      expect(table.headings.first.cells.last.value).to include('Cases/Million')
      expect(table.title).to include('TOP 5 COUNTRIES IN CASES')
    end

    it 'returns top countries in deaths' do
      table = Kovid.top(5, { location: :countries, incident: :deaths })
      expect(table.headings.first.cells.first.value).to include('Country')
      expect(table.headings.first.cells.last.value).to include('Cases/Million')
      expect(table.title).to include('TOP 5 COUNTRIES IN DEATHS')
    end

    it 'returns top states in cases' do
      table = Kovid.top(5, { location: :states, incident: :cases })
      expect(table.headings.first.cells.first.value).to include('State')
      expect(table.headings.first.cells.last.value).to include('Tests')
      expect(table.title).to include('TOP 5 STATES IN CASES')
    end

    it 'returns top states in deaths' do
      table = Kovid.top(5, { location: :states, incident: :deaths })
      expect(table.headings.first.cells.first.value).to include('State')
      expect(table.headings.first.cells.last.value).to include('Tests')
      expect(table.title).to include('TOP 5 STATES IN DEATHS')
    end

    it 'returns correct amount of records' do
      table1 = Kovid.top(3)
      expect(table1.rows.size).to eq(3)

      table2 = Kovid.top(7)
      expect(table2.rows.size).to eq(7)
    end

    it 'returns sorted stat' do
      table = Kovid.top(5)
      cases = table.columns[1].sort.reverse
      expect(cases.sort.reverse).to eq(cases)
    end

    it 'adds footers rows when records greater than 10' do
      table = Kovid.top(17)
      expect(table.rows.size).to eq(19)
    end
  end
end
