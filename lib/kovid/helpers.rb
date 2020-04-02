# frozen_string_literal: true

require 'terminal-table'
module Kovid
  module_function

  def info_table(message)
    rows = [[message.to_s]]
    puts Terminal::Table.new title: '❗️', rows: rows
  end

  # Parse date as "02 Apr, 20"
  def dateman(date)
    date_to_parse = Date.strptime(date, '%m/%d/%y').to_s
    Date.parse(date_to_parse).strftime('%d %b, %y')
  end
end
