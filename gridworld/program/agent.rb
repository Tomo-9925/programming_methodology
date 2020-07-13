# エージェントの作成，移動を行う
class Agent
  def initialize(grid, r)
    @grid = grid
    @r = r  # 乱数オブジェクト
  end

  # エージェントの移動
  def move
    AGENT_LIFETIME.times do |i|
      arrows = @grid.show_arrows  # gridから矢印の大きさを取得
      direction = select_direction(arrows)  # 矢印の情報をもとに移動する方向を決定
      @grid.record_location(direction)  # 決定した矢印からgridで位置を記録
      break if @grid.goal?  # ゴールしたとき処理を終了
    end
  end

  # エージェントの移動(評価用)
  def move_m
    AGENT_LIFETIME.times do |i|
      arrows = @grid.show_arrows
      direction = select_max_direction(arrows)
      @grid.record_location(direction)
      break if @grid.goal?
    end
  end

  private  # プライベートメソッド

  # 移動する方向を決定
  def select_direction(arrows)
    direction = 0
    tmp = @r.rand()  # 0~1の乱数を生成
    4.times do |i|
      tmp -= arrows[i]
      break if tmp <= 0
      direction += 1
    end
    direction
  end

  # 大きい矢印を選択
  def select_max_direction(arrows)
    direction = 0
    cnt = arrows.count(arrows.max)
    if cnt == 1
      direction = arrows.each_with_index.max[1]
    else
      tmp = @r.rand(0...cnt)
      arrows.each_with_index do |arrow, i|
        tmp -= 1 if arrow == arrows.max
        if tmp<0
          direction = i
          break
        end
      end
    end
    direction
  end
end