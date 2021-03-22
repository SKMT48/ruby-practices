#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  files = ARGV
  opts = ARGV.getopts('l')
  if files.empty?
    text_lines = readlines
    show_text_count(get_count_table(text_lines.join), opts)
    puts
  else
    process_files(files, opts)
  end
end

def get_count_table(text)
  { line_count: text.count("\n"), word_count: text.scan(/\s+/).count, bytesize: text.bytesize }
end

def process_files(files, opts)
  line_counts = []
  word_counts = []
  byte_size_list = []
  files.each do |file|
    count_table = get_count_table(File.read(file))
    show_text_count(count_table, opts)
    puts " #{file}"
    line_counts << count_table[:line_count]
    word_counts << count_table[:word_count]
    byte_size_list << count_table[:bytesize]
  end
  return if files.count == 1

  show_text_count({ line_count: line_counts.sum, word_count: word_counts.sum, bytesize: byte_size_list.sum }, opts)
  puts ' total'
end

def show_text_count(count_table, opts)
  if opts['l']
    print count_table[:line_count].to_s.rjust(8)
  else
    count_table.each_value { |count| print count.to_s.rjust(8) }
  end
end

main
