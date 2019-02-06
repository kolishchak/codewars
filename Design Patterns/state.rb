class AbstractState
  attr_reader :can_move, :damage
end

class SiegeState < AbstractState
  def can_move
    false
  end

  def damage
    20
  end
end

class TankState < AbstractState
  def can_move
    true
  end

  def damage
    5
  end
end

class Tank
  extend Forwardable
  attr_accessor :state

  def initialize
    @state = TankState.new
  end

  def_delegators :@state, :can_move, :damage
end