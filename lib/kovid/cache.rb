# frozen_string_literal: true

require 'typhoeus'
module Kovid
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
