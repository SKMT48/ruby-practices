#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  files = ARGV
  opts = ARGV.getopts('l')
  if files.empty?
    text = readlines
    display_format(text, opts)
    puts "\n"
  else
    with_files(files, opts)
  end
end

# ファイル指定あり
def with_files(files, opts)
  line_count = []
  word_count = []
  bytesize = []
  files.each do |file|
    text = File.read(file).lines
    line_count << text.size
    word_count << text.to_s.split.size
    bytesize << text.sum(&:bytesize)
    display_format(text, opts)
    puts " #{file}"
  end
  return if files.size == 1

  if opts['l']
    show_info(line_count.sum)
  else
    show_info(line_count.sum, word_count.sum, bytesize.sum)
  end
  puts ' total'
end

def display_format(text, opts)
  if opts['l']
    show_info(text.size)
  else
    show_info(text.size, text.to_s.split.size, text.sum(&:bytesize))
  end
end

def show_info(*file_info_lists)
  file_info_lists.each { |list| print list.to_s.rjust(8) }
end

main
