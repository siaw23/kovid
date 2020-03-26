# frozen_string_literal: true

RSpec.describe Kovid::UriBuilder do
  it 'returns a string URL given a path' do
    builder = Kovid::UriBuilder.new('/hello').url

    expect(builder).to eq('https://corona.lmao.ninja/hello')
  end
end
