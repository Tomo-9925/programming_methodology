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
  else  # オプション無しのとき第2回目の課題の通りにする
    ninzu = 2
  end
  ninzu
end

# プレイヤーの初期化
def initialize_players(option, ninzu, players)
  if ninzu != 2  # 人数を2人と指定していなかったとき
    if option.has_key?(:r)
      for i in 1..ninzu
        players << Player.new("P"+i.to_s)  # 破壊的操作はmainにも反映される
      end
    else
      for i in 1..ninzu
        players << Player.new("P"+i.to_s, i)  # 乱数のシード値を固定
      end
    end
  else  # 人数を2人と指定していたとき
    if option.has_key?(:r)
      players << Player.new("P1")
      players << Quirk.new("P2")
    else
      # 第2回の課題用のオブジェクトを作成
      players << Player.new("P1", 10)
      players << Quirk.new("P2", 20)
    end
  end
end

# じゃんけんを実行
def janken(option, kaisu, players, draw)
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
end

# 結果を表示
def show_result(option, players,draw)
  print "【最終結果】\n" if option.has_key?(:a)
  players.each do |player|
    player.result  # プレーヤごとの結果の表示
  end
  print "引き分け\t"
  print "グー #{draw.count(0)}分, "
  print "チョキ #{draw.count(1)}分, "
  print "パー #{draw.count(2)}分, "
  print "全部 #{draw.count(3)}分\n"
end