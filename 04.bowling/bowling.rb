#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数のXを10、それ以外は数値にした配列に変換する
all_fallen_pins = ARGV[0].chars.map! { |n| n == 'X' ? 10 : n.to_i }
array_per_frame = []
frames = []
frame_count = 1
score = 0

# 10フレームまでの配列をつくる
all_fallen_pins.each do |fallen_pins|
  array_per_frame << fallen_pins
  # 1〜9フレームの処理
  if frame_count <= 9
    if array_per_frame[0] == 10 || array_per_frame.length == 2
      frames << array_per_frame
      array_per_frame = []
      frame_count += 1
    end
  # 10フレームの処理
  elsif frame_count == 10
    frames << array_per_frame
    frame_count += 1
  end
end

# 配列をもとにここから下スコア計算
frames.each_with_index do |frame, i|
  # 1〜9フレームのスコア計算
  score += if i < 9
             # ストライクが連続しなかった場合
             if frame == [10] && frames[i + 1] != [10]
               frame.sum + frames[i + 1][0] + frames[i + 1][1]
             # ストライクを連続で出した場合
             elsif frame == [10] && frames[i + 1] == [10]
               frame.sum + frames[i + 1][0] + frames[i + 2][0]
             # スペアを出した場合
             elsif frame != [10] && frame.sum == 10
               frame.sum + frames[i + 1][0]
             # ストライクでもスペアでもない場合
             else
               frame.sum
             end
           # 1〜9フレーム以外(10フレーム)のスコア計算
           else
             frames[9].sum
           end
end

puts score
