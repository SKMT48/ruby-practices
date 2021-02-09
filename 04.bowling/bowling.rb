#!/usr/bin/env ruby
# frozen_string_literal: true

argument = ARGV[0]
# 引数として入力されたものを数字配列に変換
number_array = argument.chars.map! { |n| n == 'X' ? 10 : n.to_i }
frame_array = []
frames = []
frame_count = 0
score = 0

# 10フレームまでの配列をつくる
number_array.each do |down_pins|
  frame_array << down_pins
  # 1〜9フレームの処理
  if frame_count + 1 <= 9
    if frame_array[0] == 10 || frame_array.length == 2
      frames << frame_array
      frame_array = []
      frame_count += 1
    end
  # 10フレームの処理
  elsif frame_count + 1 == 10
    frames << frame_array
    frame_count += 1
  end
end

# 配列をもとにここから下スコア計算
frames.each_with_index do |frame, i|
  # 1〜9フレームのスコア計算
  if i + 1 <= 9
    # ストライクが連続しなかった場合
    if frame == [10] && frames[i + 1] != [10]
      score += frame.sum + frames[i + 1][0] + frames[i + 1][1]
    # ストライクを連続で出した場合
    elsif frame == [10] && frames[i + 1] == [10]
      score += frame.sum + frames[i + 1][0] + frames[i + 2][0]
    # スペアを出した場合
    elsif frame != [10] && frame.sum == 10
      score += frame.sum + frames[i + 1][0]
    # ストライクでもスペアでもない場合
    elsif frame != [10] && frame.sum != 10
      score += frame.sum
    end
  # 10フレームのスコア計算
  elsif i + 1 == 10
    score += frames[9].sum
  end
end

p score
