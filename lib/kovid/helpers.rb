# frozen_string_literal: true

require 'terminal-table'
module Kovid
  module_function

  def info_table(message)
    rows = [[message.to_s]]
    puts Terminal::Table.new title: '❗️', rows: rows
  end
end
