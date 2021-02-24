#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'

def add_space(files)
  files.push('') while files.count % 3 != 0
end

# 配列の行列反転
def invert_matrix(files)
  files_dual_array = []
  files.each_slice(files.count / 3) do |file|
    files_dual_array.push(file)
  end
  files_dual_array.transpose.flatten
end

# lオプション以外の表示
def show_standard(files)
  add_space(files)
  line_break_count = 0
  invert_matrix(files).each do |file|
    line_break_count += 1
    print file.to_s.ljust(20)
    print "\n" if (line_break_count % 3).zero?
  end
end

# ここからlオプション
def file_type(file)
  to_one_char(File.stat(file).ftype)
end

def to_one_char(ftype)
  {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'f',
    'link' => 'l',
    'socket' => 's',
    'unknown' => 'u'
  }[ftype]
end

def to_octal(file)
  File.stat(file).mode.to_s(8)
end

def owner_rwx(file)
  to_rwx(to_octal(file)[-3].to_i)
end

def group_rwx(file)
  to_rwx(to_octal(file)[-2].to_i)
end

def other_rwx(file)
  to_rwx(to_octal(file)[-1].to_i)
end

def permission(file)
  "#{owner_rwx(file)}#{group_rwx(file)}#{other_rwx(file)}"
end

def to_rwx(octal)
  {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }[octal]
end

def hard_link(file)
  File.stat(file).nlink
end

def owner_name(file)
  Etc.getpwuid(File.stat(file).uid).name
end

def group_name(file)
  Etc.getgrgid(File.stat(file).gid).name
end

def bite_size(file)
  File.stat(file).size.to_s.rjust(5)
end

def time_stamp(file)
  File.stat(file).ctime.strftime('%-m %e %R')
end

def total_blocks(files)
  files_blocks = []
  files.each do |file|
    files_blocks << File.stat(file).blocks
  end
  files_blocks.sum
end

def show_details(files)
  puts "total #{total_blocks(files)}"
  files.each do |file|
    puts "#{file_type(file)}#{permission(file)}  #{hard_link(file)} #{owner_name(file)}  #{group_name(file)} #{bite_size(file)}  #{time_stamp(file)} #{file}"
  end
end
# ここまでがlオプション

def opts_a?(opts_a)
  if opts_a == true
    Dir.entries('.').sort
  else
    Dir.glob('*').sort
  end
end

def opts_r?(files, opts_r)
  files.reverse! if opts_r == true
  files
end

def opts_l?(files, opts_l)
  if opts_l == true
    show_details(files)
  else
    show_standard(files)
  end
end

def ls_cmd
  options = ARGV.getopts('a', 'r', 'l')
  pass_opts_a = opts_a?(options['a'])
  pass_opts_ar = opts_r?(pass_opts_a, options['r'])
  opts_l?(pass_opts_ar, options['l'])
end

ls_cmd
