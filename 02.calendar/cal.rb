#!/usr/bin/env ruby
require "date"
require "optparse"

today = Date.today #今日の日付
options = ARGV.getopts('y:m:') #オプション設定
oneyear = options['y'] #オプションのy引数を受け取る  
oneyear ||= today.year #nil(オプションを指定しない)の場合
onemonth = options['m'] #オプションm引数を受け取る
onemonth ||= today.month #nil(オプションを指定しない)の場合
year = Date.new(oneyear.to_i, onemonth.to_i, 1).year
month = Date.new(oneyear.to_i, onemonth.to_i, 1).month 
firstday = Date.new(year, month, 1) #月初めの1日
lastday = Date.new(year, month, -1) #月終わりの日
week = %w(日 月 火 水 木 金 土)
wday = Date.new(year, month, 1).wday

puts "#{month}月 #{year}".center(20)
puts week.join(" ")
print "   " * wday #月初めの曜日によってスペースを追加する

(firstday..lastday).each do |x|
    print x.day.to_s.rjust(2)+" " #日付を右揃えにしてスペースを入れる
    wday += 1
    if wday % 7 == 0 #wdayが７の倍数のとき改行を入れる
        print "\n"
    end
end
puts "\n"
