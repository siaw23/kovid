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

  def comma_delimit(number)
    number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(',').reverse
  end

  # Insert + sign to format positive numbers
  def add_plus_sign(num)
    num.to_i.positive? ? "+#{comma_delimit(num)}" : comma_delimit(num).to_s
  end

  def format_country_history_numbers(load)
    load['timeline'].values.map(&:values).transpose.each do |data|
      data.map! { |number| Kovid.comma_delimit(number) }
    end
  end
end
