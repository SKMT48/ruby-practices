#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  files = ARGV
  opts = ARGV.getopts('l')
  if files.empty?
    text = readlines
    no_files(text, opts)
  else
    with_files(files, opts)
  end
end

# ファイル指定なし
def no_files(text, opts)
  if opts['l']
    display_aligned(text.size)
  else
    display_aligned(text.size, text.to_s.split.size, text.sum { |one_char| one_char.to_s.bytesize })
  end
  print "\n"
end

# ファイル指定有り
def with_files(files, opts)
  files.each do |file|
    if opts['l']
      display_aligned(line_count(file))
    else
      display_aligned(line_count(file), word_count(file), byte_size(file))
    end
    print " #{file}\n"
  end
  if opts['l'] && files.size >= 2
    display_aligned(total_line_count(files))
    print " total\n"
  elsif files.size >= 2
    display_aligned(total_line_count(files), total_word_count(files), total_byte_size(files))
    print " total\n"
  end
end

def display_aligned(*file_infomations)
  file_infomations.each { |info| print info.to_s.rjust(8) }
end

def line_count(file)
  File.read(file).count("\n")
end

def word_count(file)
  File.read(file).to_s.scan(/\s+/).count
end

def byte_size(file)
  File.stat(file).size
end

def total_line_count(files)
  files.sum { |file| line_count(file) }
end

def total_word_count(files)
  files.sum { |file| word_count(file) }
end

def total_byte_size(files)
  files.sum { |file| byte_size(file) }
end

main
