#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'

COLUMN_COUNT = 3

FILE_TYPE =
  {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'f',
    'link' => 'l',
    'socket' => 's',
    'unknown' => 'u'
  }.freeze

PERMISSION_PATTERN =
  {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }.freeze

def ls_cmd
  options = ARGV.getopts('a', 'r', 'l')
  files = show_all(options['a'])
  sorted_files = options['r'] ? files.reverse : files
  show_format(sorted_files, options['l'])
end

def show_all(opts_a)
  if opts_a
    Dir.glob('*', File::FNM_DOTMATCH).sort
  else
    Dir.glob('*').sort
  end
end

def show_format(files, opts_l)
  if opts_l
    show_details(files)
  else
    show_standard(files)
  end
end

# lオプション以外の表示
def show_standard(files)
  invert_matrix(add_space(files)).each do |nested_files|
    nested_files.each do |file|
      print file.to_s.ljust(20)
    end
    print "\n"
  end
end

def add_space(files)
  copy_files = files.clone
  copy_files.push('') while copy_files.count % COLUMN_COUNT != 0
  copy_files
end

def invert_matrix(copy_files)
  copy_files.each_slice(copy_files.count / COLUMN_COUNT).to_a.transpose
end

# ここからlオプション
def show_details(files)
  puts "total #{total_blocks(files)}"
  files.each do |file|
    stat = File.stat(file)
    puts "#{file_type(stat)}#{permission(stat)}  #{hard_link(stat)} #{owner_name(stat)}  #{group_name(stat)} #{byte_size(stat)}  #{time_stamp(stat)} #{file}"
  end
end

def total_blocks(files)
  files.sum { |file| File.stat(file).blocks }
end

def file_type(stat)
  FILE_TYPE[stat.ftype]
end

def permission(stat)
  [-3, -2, -1].map do |index|
    PERMISSION_PATTERN[stat.mode.to_s(8)[index].to_i]
  end.join
end

def hard_link(stat)
  stat.nlink
end

def owner_name(stat)
  Etc.getpwuid(stat.uid).name
end

def group_name(stat)
  Etc.getgrgid(stat.gid).name
end

def byte_size(stat)
  stat.size.to_s.rjust(5)
end

def time_stamp(stat)
  stat.ctime.strftime('%-m %e %R')
end

ls_cmd
