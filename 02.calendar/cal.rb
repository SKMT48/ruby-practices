#!/usr/bin/env ruby
require "date"
require "optparse"

today = Date.today 
options = ARGV.getopts('y:m:') #オプション設定
year = options['y'].nil? ? today.year : options['y'].to_i #引数無しの場合、今年が代入される
month = options['m'].nil? ? today.month : options['m'].to_i #引数無しの場合、今月が代入される
firstday = Date.new(year, month, 1) 
lastday = Date.new(year, month, -1) 
week = %w(日 月 火 水 木 金 土)
wday = Date.new(year, month, 1).wday

puts "#{month}月 #{year}".center(20)
puts week.join(" ")
print "   " * wday #月初めの曜日によってスペースを追加する

(firstday..lastday).each do |date|
    print date.day.to_s.rjust(2)+" " #日付を右揃えにしてスペースを入れる
    if date.saturday?  
        print "\n"
    end
end
puts "\n"
