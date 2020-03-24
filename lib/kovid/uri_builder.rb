# frozen_string_literal: true

require 'uri'

module Kovid
  class UriBuilder
    attr_reader :path

    BASE_URI = 'corona.lmao.ninja'

    def initialize(path = '')
      @path = path
    end

    def url
      URI::HTTPS.build(host: BASE_URI, path: path).to_s
    end
  end
end
