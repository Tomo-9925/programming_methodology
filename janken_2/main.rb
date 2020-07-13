#! /usr/bin/env ruby

require 'optparse'  # コマンドライン引数を取得するためのライブラリ
require './player.rb'  # Playerクラスを記述
require './function.rb'  # 関数を記述

#コマンドライン引数を取得
option = {}  # コマンドライン引数を格納するための連想配列を初期化
OptionParser.new do |opt|
  opt.on('-a', '--all', "対決の情報をすべて表示します．") {|v| option[:a] = v}
  opt.on('-r', '--random', "使用するプレーヤーの種類とPlayerの出す手をランダムする．") {|v| option[:r] = v}
  opt.on('-p VALUE', '--player VALUE', "プレイヤー数を指定します．") {|v| option[:p] = v}
  opt.parse!(ARGV)  # 引数はじゃんけんの回数
end

# コマンドライン引数のチェック
kaisu = check_kaisu(ARGV)
ninzu = check_ninzu(option)

# プレイヤーの作成
player_kinds = [Player, Order, Stone, Scissors, Paper]  # プレーヤーの種類を格納 
players = []  # プレイヤー情報をこの配列に格納する
initialize_players(option, ninzu, player_kinds, players)

# じゃんけん
draw = []  # 引き分けの記録 -> 手の番号またはすべての手が出たとき->3
print "【じゃんけん開始】\n\n" if option.has_key?(:a)  # aオプションがあるとき表示
kaisu.times do |i|
  # ループ回数の表示
  puts "【第#{(i+1).to_s}回戦】" if option.has_key?(:a)

  # プレーヤーに手を出してもらいhandsに記録
  hands = []
  print "[" if option.has_key?(:a)
  players.each do |player|
    hands << player.hand
    if option.has_key?(:a)
      case hands.last
      when 0
        print '"グー", '
      when 1
        print '"チョキ", '
      when 2
        print '"パー", '
      end
    end
  end
  print "\b\b]\n" if option.has_key?(:a)

  # 引き分けの場合
  hand_kinds = hands.uniq  # 配列の重複を削除してhand_kindsに格納
  if hand_kinds.length == 3 or hand_kinds.length == 1  # すべての種類の手が出たとき，全員が同じ手を出したとき
    print "引き分け\n\n"  if option.has_key?(:a)
    if hand_kinds.length == 3
      draw << 3  # 4をdrawに追加
    else
      draw << hand_kinds.first  # hand_kindsに入っている手をdrawに追加
    end
    next  # continue
  end

  # 勝ちの手を記録
  win_hand = -1
  if hand_kinds.include?(0)
    if hand_kinds.include?(1)
      win_hand = 0  # グー vs チョキ -> グー
    elsif hand_kinds.include?(2)
      win_hand = 2  # グー vs パー -> パー
    end
  elsif hand_kinds.include?(1)
    if hand_kinds.include?(2)
      win_hand = 1  # チョキ vs パー -> チョキ
    end
  end

  # Playerに勝ちのを報告
  players.each_with_index do |player, idx|
    if hands[idx] == win_hand
      player.notify
      print "#{player.name}, "  if option.has_key?(:a)
    end
  end
  print "\b\bの勝ち\n\n" if option.has_key?(:a)
end

# 最終結果出力
show_result(option, players, draw)