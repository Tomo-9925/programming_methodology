# 通常のプレイヤークラス
class Player
  def initialize(name="名無しさん", seed=-1)
    @name = name
    @win = []  # 勝ったときの手を記録
    @probability = [1.0/3, 1.0/3, 1.0/3]  # 手のそれぞれ出す確率
    @hand = -1  # 0から順にグー，チョキ，パー
    @rand = seed==-1 ? Random.new : Random.new(seed)
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
    print "#{@name} "
    print "#{self.class}\t"
    print "#{@win.size}勝\t"
    print "グー #{@win.count(0)}勝, "
    print "チョキ #{@win.count(1)}勝, "
    print "パー #{@win.count(2)}勝\n"
  end
end

# グー・チョキ・パーを順番に出すクラス
class Order < Player
  def initialize(name="名無しさん", seed=-1)
    @name = name
    @win = []
    @hand = -1 
  end

  def hand
    @hand += 1
    @hand = 0 if @hand == 3
    @hand
  end
end

# グーのみを出すクラス
class Stone < Order
  def initialize(name="名無しさん", seed=-1)
    super
    @hand = 0
  end

  def hand
    @hand
  end
end

# チョキのみを出すクラス
class Scissors < Order
  def initialize(name="名無しさん", seed=-1)
    super
    @hand = 1
  end

  def hand
    @hand
  end
end

# パーのみを出すクラス
class Paper < Order
  def initialize(name="名無しさん", seed=-1)
    super
    @hand = 2
  end

  def hand
    @hand
  end
end