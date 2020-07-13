#! /usr/bin/env ruby

require 'optparse'  # コマンドライン引数を取得するためのライブラリ
require './player.rb'  # Playerクラスを記述
require './function.rb'  # 関数を記述

#コマンドライン引数を取得
option = {}  # コマンドライン引数を格納するための連想配列を初期化
OptionParser.new do |opt|
  opt.on('-a', '--all', "対決の情報をすべて表示します．") {|v| option[:a] = v}
  opt.on('-r', '--random', "手をランダムに出すようにします．") {|v| option[:r] = v}
  opt.on('-p VALUE', '--player VALUE', "プレイヤー数を指定します．") {|v| option[:p] = v}
  opt.parse!(ARGV)  # 引数はじゃんけんの回数
end

# コマンドライン引数のチェック
kaisu = check_kaisu(ARGV)
ninzu = check_ninzu(option)

# プレイヤーの作成
players = []  # プレイヤー情報をこの配列に格納する
initialize_players(option, ninzu, players)

# じゃんけん
draw = []  # 引き分けの記録 -> 手の番号またはすべての手が出たとき->3
janken(option, kaisu, players, draw)

# 最終結果出力
show_result(option, players, draw)