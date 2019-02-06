class Fly
  def move(unit)
    unit.position += 10
  end
end

class Walk
  def move(unit)
    unit.position += 1
  end
end

class Viking
  attr_accessor :position, :move_behavior

  def initialize
    @position = 0
    @move_behavior = Walk.new
  end

  def move
    move_behavior.move self
  end
end
