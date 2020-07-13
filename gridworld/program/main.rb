#! /usr/bin/env ruby

# 定数
N = 10  # グリッドサイズ
GOAL_X = 5  # ゴールのX座標
GOAL_Y = 5  # ゴールのY座標
LEARNING_LIMIT = 700  # 学習回数
AGENT_LIFETIME = 85  # エージェントの寿命
P = 1e-2  # 報酬
T = 10  # 報酬で矢印を遡ることができる回数
VAL = 500   # 評価を行う回数
# オプション
USE_SEED = true  # 固定された疑似乱数を使用する
RAND_GOAL = false  # ゴール位置をランダムにする
SHOW_DETAIL = false  # 実験の結果など詳細を表示させる
TRIAL_LIMIT = 100  # 実験回数，ARROWSがTRUEのとき無効

# 構造体
ARROWS = Struct.new(:up, :down, :left, :right)
LOCATION = Struct.new(:x, :y, :direction)

# クラスと関数の読み込み
require './grid.rb'
require './agent.rb'
require './function.rb'

# メイン

# 0.step(1e-1, 1e-3) { |n|
#   P = n

  # 乱数の生成
  R = USE_SEED ? Random.new(150) : Random.new()  # 乱数オブジェクトの生成

  check_const()  # 定数の確認
  show_value() if SHOW_DETAIL  # 定数の表示

  l_goal_rates = []  # 学習時のゴール率を記録していく配列
  l_all_move_cnts = []  # 学習時の移動回数の平均を記録する配列列
  r_goal_rates = []  # 評価時のゴール率を記録していく配列
  r_all_move_cnts = []  # 評価時の移動回数の平均を記録する配列
  threads = []  # スレッドを格納する配列
  num = SHOW_DETAIL ? 1 : TRIAL_LIMIT  # 実験回数の決定
  num.times do |t|
    threads << Thread.start do
      # 実験に使用する乱数オブジェクトの生成
      r = Random.new(R.rand(0...1000000))
      # ゴールの座標を決める
      goal = RAND_GOAL ? LOCATION.new(r.rand(N), r.rand(N), -1) : LOCATION.new(GOAL_X-1, GOAL_Y-1, -1)
      # directionの初期値は-1とする
      grid = Grid.new(goal)  # グリッドワールドの作成

      # 学習
      goal_cnt = 0  # ゴール回数を記録
      move_cnts = []
      LEARNING_LIMIT.times do |i|
        start = set_start(goal, r)  # スタート位置を決定
        grid.clear(start)  # グリッドのhistoryの初期化とスタート位置のセット
        agent = Agent.new(grid, r)  # エージェントの初期化
        agent.move  # エージェントを移動させる
        move_cnts << grid.move_count  # エージェントの移動回数を記録
        # grid.show_history if SHOW_DETAIL  # エージェントの履歴を表示する
        if grid.goal?  # もしエージェントがゴールしたとき
          # puts "ゴールしました" if SHOW_DETAIL
          grid.update  # グリッドの矢印を更新する
          goal_cnt += 1  # ゴール回数をカウントする
        else
          # puts "ゴールできませんでした" if SHOW_DETAIL
          # grid.penalty  # 罰を与える
        end
        # puts nil if SHOW_DETAIL  # 改行
      end
      l_all_move_cnts << move_cnts.inject(:+)/move_cnts.length.to_f  # 移動回数の平均を記録
      l_goal_rates << goal_cnt/LEARNING_LIMIT.to_f  # ゴール率を記録
      grid.show_grid if SHOW_DETAIL  # グリッドの情報を表示

      # 評価
      goal_cnt = 0
      move_cnts = []
      VAL.times do |i|
        start = set_start(goal, r)
        grid.clear(start)
        agent = Agent.new(grid, r)
        agent.move_m
        move_cnts << grid.move_count
        goal_cnt += 1 if grid.goal?
      end
      r_all_move_cnts << move_cnts.inject(:+)/move_cnts.length.to_f
      r_goal_rates << goal_cnt/VAL.to_f
    end
  end

  # すべてのスレッドが終了するのを待つ
  threads.each do |thr|
    thr.join
  end

  # 結果の表示
  if SHOW_DETAIL
    puts nil
    puts "学習時のゴール率: #{l_goal_rates.last.to_s}"
    puts "学習時のエージェントの平均行動回数: #{l_all_move_cnts.last.to_s}"
    puts "学習後のゴール率: #{r_goal_rates.last.to_s}"
    puts "学習後のエージェントの平均行動回数: #{r_all_move_cnts.last.to_s}"
  else
    # 学習中
    p l_goal_rates.max  # 最大値
    p l_goal_rates.inject(:+)/l_goal_rates.length  # 平均値
    p l_goal_rates.min  # 最小値
    p l_all_move_cnts.inject(:+)/l_all_move_cnts.length  # 移動回数の平均
    # 学習後
    p r_goal_rates.max  # 最大値
    p r_goal_rates.inject(:+)/r_goal_rates.length  # 平均値
    p r_goal_rates.min  # 最小値
    p r_all_move_cnts.inject(:+)/l_all_move_cnts.length  # 移動回数の平均
    # print "#{l_goal_rates.max}\t#{l_goal_rates.inject(:+)/l_goal_rates.length}\t#{l_goal_rates.min}\t#{l_all_move_cnts.inject(:+)/l_all_move_cnts.length}\t#{r_goal_rates.max}\t#{r_goal_rates.inject(:+)/r_goal_rates.length}\t#{r_goal_rates.min}\t#{r_all_move_cnts.inject(:+)/l_all_move_cnts.length}\n"
  end
# }