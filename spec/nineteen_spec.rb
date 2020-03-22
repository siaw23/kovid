# frozen_string_literal: true

RSpec.describe Kovid::Nineteen do


  describe "whatis" do
    it "defines COVID-19" do
      text = "Coronavirus disease 2019 (COVID-19) is an infectious disease caused by severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2)."

      expect(Kovid::Nineteen.whatis).to eq(text)
    end
  end

  describe "country(name)" do
    let(:country) { "ghana" }
    it "returns table with country data" do
      table = Kovid::Nineteen.country(country)

      expect(table.title).to eq("Ghana")
    end
  end

  describe "country_full(name)" do
    let(:country) { "ghana" }
    it "returns table with country data" do
      table = Kovid::Nineteen.country_full(country)

      expect(table.title).to eq("Ghana")
    end
  end

  # describe "country_full(names_array)" do
  #   let(:country) { ["ghana", "poland"] }
  #   it "returns table with country data" do
  #     table = Kovid::Nineteen.country_comparison(country)

  #     expect(table.headings.values).to eq("Ghana")
  #   end
  # end
end
