# ARGVの値の確認と値の数値化
def check_kaisu(hikisu)
  if hikisu.empty?  # 引数が入力されていないとき
    abort "じゃんけんの回数を入力してください．"
  elsif hikisu.size != 1  # 引数が複数入力されていたとき
    abort "引数は複数入力しないでください．"
  else
    begin
      kaisu = ARGV[0].to_i
    rescue  # 引数を数値化できなかったとき
      abort "じゃんけんの回数は半角数字で入力してください．"
    end
    if kaisu < 1  # 1以下の数字が入力されていたとき
      abort "じゃんけんの回数は1回以上に設定してください．"
    end
  end
  kaisu  # returnを省略
end

# pオプションの値の確認と値の数値化
def check_ninzu(option)
  if option.has_key?(:p)  # pオプションが指定されていたとき
    begin
      ninzu = option[:p].to_i
    rescue  # pオプションの値が数値化できなかったとき
      abort "プレイヤー数は半角数字で入力してください．"
    end
    if ninzu < 2  # 2以下の数字が入力されていたとき
      abort "プレイヤー数は2人以上に設定してください．"
    end
  else  # オプション無しのとき2人にする
    ninzu = 2
  end
  ninzu
end

# プレイヤーの初期化
def initialize_players(option, ninzu, player_kinds, players)
  r = option.has_key?(:r) ? Random.new() : Random.new(10)
  ninzu.times do |i|
    players << player_kinds[r.rand(player_kinds.length)].new("P"+(i+1).to_s, r.rand)
  end
end

# 結果を表示
def show_result(option, players,draw)
  print "【最終結果】\n" if option.has_key?(:a)
  players.each do |player|
    player.result  # プレーヤごとの結果の表示
  end
  print "引き分け\t\t"
  print "グー #{draw.count(0)}分, "
  print "チョキ #{draw.count(1)}分, "
  print "パー #{draw.count(2)}分, "
  print "全部 #{draw.count(3)}分\n"
end