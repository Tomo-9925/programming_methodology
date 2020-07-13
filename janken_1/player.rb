# 通常のプレイヤークラス
class Player
  def initialize(name="名無しさん", seed=-1)
    @name = name
    @win = []  # 勝ったときの手を記録
    @probability = [1.0/3, 1.0/3, 1.0/3]  # 手のそれぞれ出す確率
    @hand = -1  # 0から順にグー，チョキ，パー
    if seed == -1
      @rand = Random.new  # 乱数オブジェクトを作成
    else
      @rand = Random.new(seed)  # シードを指定して乱数オブジェクトを作成
    end
  end

  # プレイヤー名を返す
  def name
    @name
  end

  # 手を出す
  def hand
    @hand = 0
    tmp = @rand.rand
    3.times do |i|
      tmp -= @probability[i]
      break if tmp < 0
      @hand += 1
    end
    @hand
  end

  # 勝ちの報告の通知を受ける
  def notify
    @win << @hand  # 出した手をwin配列に格納
  end

  # 勝数を出力する
  def result
    print "#{@name}\t"
    print "#{@win.size}勝\t"
    print "グー #{@win.count(0)}勝, "
    print "チョキ #{@win.count(1)}勝, "
    print "パー #{@win.count(2)}勝\n"
  end
end

# パーを出しやすいプレーヤークラス
class Quirk < Player
  def initialize(name="名無しさん", seed=-1)
    super  # 親クラスのinitializeを実行
    @probability = [1.0/4, 1.0/4, 1.0/2]  # 確率を上書き
  end
end