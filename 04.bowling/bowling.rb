#!/usr/bin/env ruby
# frozen_string_literal: true

follen_pins = ARGV[0]
all_fallen_pins = follen_pins.chars.map! { |n| n == 'X' ? 10 : n.to_i }
throws_per_frame = []
frames = []
frame_count = 1
score = 0

# 10フレームまでの配列をつくる
all_fallen_pins.each do |pins|
  throws_per_frame << pins
  # 1〜9フレームの処理
  if frame_count <= 9
    if throws_per_frame[0] == 10 || throws_per_frame.length == 2
      frames << throws_per_frame
      throws_per_frame = []
      frame_count += 1
    end
  # 10フレームの処理
  elsif frame_count == 10
    frames << throws_per_frame
    frame_count += 1
  end
end

# 配列をもとにここから下スコア計算
frames.each_with_index do |frame, i|
  # 1〜9フレームのスコア計算
  if i < 9
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
    else
      score += frame.sum
    end
  # 10フレームのスコア計算
  else
    score += frames[9].sum
  end
end
puts score
