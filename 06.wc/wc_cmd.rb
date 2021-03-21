#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  files = ARGV
  opts = ARGV.getopts('l')
  if files.empty?
    text_array = readlines
    show_file_info(text_array.join, opts)
    puts "\n"
  else
    process_files(files, opts)
  end
end

# ファイル指定が有る場合の処理
def process_files(files, opts)
  file_text_list = []
  files.each do |file|
    file_text = File.read(file)
    show_file_info(file_text, opts)
    puts " #{file}"
    file_text_list << file_text
  end
  return if files.count == 1

  show_file_info(file_text_list.join, opts)
  puts ' total'
end

def show_file_info(text, opts)
  text_info_list = { line_count: text.count("\n"), word_count: text.scan(/\s+/).count, bytesize: text.bytesize }
  if opts['l']
    print text_info_list[:line_count].to_s.rjust(8)
  else
    text_info_list.each_value { |info| print info.to_s.rjust(8) }
  end
end

main
