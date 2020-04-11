# frozen_string_literal: true

require 'typhoeus'

# rubocop:disable Style/Documentation
module Kovid
  # rubocop:enable Style/Documentation
  # Caches HTTP requests
  class Cache
    def initialize
      @memory = {}
    end

    def get(request)
      @memory[request]
    end

    def set(request, response)
      @memory[request] = response
    end
  end

  Typhoeus::Config.cache = Cache.new
end
