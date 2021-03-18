#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  files = ARGV
  opts = ARGV.getopts('l')
  if files.empty?
    file = readlines
    show_file_info(file.count, file.to_s.split.size, file.sum(&:bytesize), opts)
    puts "\n"
  else
    process_files(files, opts)
  end
end

# ファイル指定が有る場合の処理
def process_files(files, opts)
  line_count_lists = []
  word_count_lists = []
  bytesize_lists = []
  files.each do |file|
    readed_file = File.read(file)
    line_count = readed_file.count("\n")
    word_count = readed_file.scan(/\s+/).count
    line_count_lists << line_count
    word_count_lists << word_count
    bytesize_lists << readed_file.bytesize
    show_file_info(line_count, word_count, readed_file.bytesize, opts)
    puts " #{file}"
  end
  return if files.count == 1

  show_file_info(line_count_lists.sum, word_count_lists.sum, bytesize_lists.sum, opts)
  puts ' total'
end

def show_file_info(line_count, word_count, bytesize, opts)
  if opts['l']
    print line_count.to_s.rjust(8)
  else
    [line_count, word_count, bytesize].each { |info| print info.to_s.rjust(8) }
  end
end

main
