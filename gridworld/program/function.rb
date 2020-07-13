# 定数の確認
def check_const
  if N < 2
    abort "グリッドの大きさを変更してください"
  elsif GOAL_X < 1 or N < GOAL_X
    abort "ゴールの位置を変更してください"
  elsif GOAL_Y < 1 or N < GOAL_Y
    abort "ゴールの位置を変更してください"
  elsif LEARNING_LIMIT < 1
    abort "LEARNING_LIMITを変更してください"
  elsif AGENT_LIFETIME < 1
    abort "AGENT_LIFETIMEを変更してください"
  elsif T < 0
    abort "Tを変更してください"
  elsif TRIAL_LIMIT < 1
    abort "実験回数を変更してください"
  elsif !(USE_SEED.is_a?(TrueClass) or USE_SEED.is_a?(FalseClass))
    abort "USE_SEEDに真偽値を入力してください"
  elsif !(RAND_GOAL.is_a?(TrueClass) or RAND_GOAL.is_a?(FalseClass))
    abort "RAND_GOALに真偽値を入力してください"
  elsif !(SHOW_DETAIL.is_a?(TrueClass) or SHOW_DETAIL.is_a?(FalseClass))
    abort "SHOW_DETAILに真偽値を入力してください"
  end
end

# 定数の値を出力する
def show_value
  puts "グリッドサイズ: #{N.to_s}, 学習回数: #{LEARNING_LIMIT.to_s}, エージェントの寿命: #{AGENT_LIFETIME.to_s},"
  puts "報酬: #{P.to_s}, 履歴: #{T.to_s}, 評価回数: #{VAL.to_s},"
  print "シード値: "
  if USE_SEED
    print "固定, "
  else
    print "ランダム, "
  end
  print "ゴール: "
  if RAND_GOAL
    puts "ランダム"
  else
    puts "固定"
  end
  puts nil
end

# スタートとゴールの座標を表示する
def show_location(start, goal)
  puts "スタート: (#{(start[0]+1).to_s}, #{(start[1]+1).to_s}), ゴール: (#{(goal[0]+1).to_s}, #{(goal[1]+1).to_s})"
end

# ゴールと同じ座標にならないようにスタートする座標を決定する
def set_start(goal, r)
  location = LOCATION.new(r.rand(N), r.rand(N), -1)
  while location == goal
    location = LOCATION.new(r.rand(N), r.rand(N), -1)
  end
  location
end