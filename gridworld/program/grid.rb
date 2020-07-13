# グリッド作成，変更，エージェントの行動の記録を行う
class Grid
  def initialize(goal)
    # @world[N][N]にArrowを格納
    @world = Array.new(N).map{Array.new(N)}
    N.times do |i|
      N.times do |j|
        if i==0 and j==0  # 左上
          @world[i][j] = ARROWS.new(0, 1.0/2, 0, 1.0/2)
        elsif i==0 and j==N-1  # 右上
          @world[i][j] = ARROWS.new(0, 1.0/2, 1.0/2, 0)
        elsif i==N-1 and j==0  # 左下
          @world[i][j] = ARROWS.new(1.0/2, 0, 0, 1.0/2)
        elsif i==N-1 and j==N-1  # 右下
          @world[i][j] = ARROWS.new(1.0/2, 0, 1.0/2, 0)
        elsif i==0  # 上
          @world[i][j] = ARROWS.new(0, 1.0/3, 1.0/3, 1.0/3)
        elsif i==N-1  # 下
          @world[i][j] = ARROWS.new(1.0/3, 0, 1.0/3, 1.0/3)
        elsif j==0  # 左
          @world[i][j] = ARROWS.new(1.0/3, 1.0/3, 0, 1.0/3)
        elsif j==N-1  # 右
          @world[i][j] = ARROWS.new(1.0/3, 1.0/3, 1.0/3, 0)
        else  # その他
          @world[i][j] = ARROWS.new(1.0/4, 1.0/4, 1.0/4, 1.0/4)
        end
      end
    end
    @start = LOCATION.new()  # LOCATION構造体で初期化
    @goal = goal
    @history = []  # 行動をエージェントの行動を記録する
  end

  # historyの初期化とスタート位置のセット
  def clear(start)
    @history.clear  # 配列を空にする
    @history << start
  end

  # historyをもとに現在地の矢印の情報を返す
  def show_arrows
    @world[@history.last[:y]][@history.last[:x]]
  end

  # Agentの場所を記録
  def record_location(direction)
    location = @history.last.dup  # 最後の位置の情報を複製
    if direction == 0
      location[:y] -= 1
    elsif direction == 1
      location[:y] += 1
    elsif direction == 2
      location[:x] -= 1
    elsif direction == 3
      location[:x] += 1
    end
    @history.last[:direction] = direction  # 移動する方向を記録
    @history << location
  end

  # 矢印の大きさを更新する
  # 考察のために使用するコードをコメントアウトしています．
  def update
    # T.times do |t|
    #   i = @history.length - 2 - t  # 読み込むhistoryの番号
    #   break if i < 0  # 遡れなかったとき
    num = T>@history.length-1 ? @history.length-1 : T  # T回遡れないとき，履歴の長さに合わせる．
    num.times do |t|
      i = @history.length - 2 - t  # 読み込むhistoryの番号
      l = @history[i]  # 見やすくするためにポインタをコピー

      tmp1 = 1.0  - @world[l[:y]][l[:x]][l[:direction]]

      # 大きくする矢印の大きさを変更
      @world[l[:y]][l[:x]][l[:direction]] += ( P * (num-t+1) / num )
      # @world[l[:y]][l[:x]][l[:direction]] += ( P * (T-t+1) / T )
      # 1を超えたときは1にする
      @world[l[:y]][l[:x]][l[:direction]] = 1.0 if @world[l[:y]][l[:x]][l[:direction]] > 1.0

      tmp2 = 1.0  - @world[l[:y]][l[:x]][l[:direction]]

      # 小さくする矢印の大きさを変更
      4.times do |j|
        @world[l[:y]][l[:x]][j] = tmp2 * (@world[l[:y]][l[:x]][j] / tmp1) if j != l[:direction]  # tmp2==0 -> NaN
        @world[l[:y]][l[:x]][j] = 0.0 if @world[l[:y]][l[:x]][j].nan?  # NaNになったときの処理
      end
    end
  end

  # 罰を与える
  def penalty
    num = @history.length - 1
    num.times do |t|
      i = @history.length - 2 - t  # 読み込むhistoryの番号
      l = @history[i]  # 見やすくするためにポインタをコピー

      tmp1 = 1.0  - @world[l[:y]][l[:x]][l[:direction]]

      # 小さくする矢印の大きさを変更
      @world[l[:y]][l[:x]][l[:direction]] -= ( P * (num-t+1) / num )

      tmp2 = 1.0  - @world[l[:y]][l[:x]][l[:direction]]

      # 大きくする矢印の大きさを変更
      4.times do |j|
        @world[l[:y]][l[:x]][j] = tmp2 * (@world[l[:y]][l[:x]][j] / tmp1) if j != l[:direction]
      end
    end
  end

  def move_count
    @history.length-1
  end

  # 履歴を表示
  def show_history
    @history.length.times do |i|
      print "(#{(@history[i][:x]+1).to_s},#{(@history[i][:y]+1).to_s})->"
    end
    print "\b\b\n"
  end

  # グリッドの矢印の数字を整数で表示
  def show_grid
    N.times do |i|
      print "["
      N.times do |j|
        print "["
        4.times do |k|
          print "#{(@world[i][j][k]*10).floor.to_s}, "  # 切り捨てして表示
        end
        print "\b\b], "
      end
      print "\b\b],\n"
    end
    puts nil

    # グリッドの矢印を感じで表示
    N.times do |i|
      N.times do |j|
        if i == @goal[:x] and j == @goal[:y]
          print "ゴ"  # ゴールを表示
        else
          arrows = @world[i][j]
          if arrows.count(arrows.max) == 1
            case arrows.each_with_index.max[1]  # 矢印の最大値（構造体なので書き方が複雑）
            when 0
              print "上"
            when 1
              print "下"
            when 2
              print "左"
            when 3
              print "右"
            end
          else
            print "謎"
          end
        end
      end
      puts nil
    end
  end

  # Agentのhistoryをもとに現在地がゴールかを調べる
  def goal?
    @history.last == @goal
  end
end