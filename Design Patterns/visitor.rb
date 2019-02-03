module Visitable
  def accept(visitor)
    visitor.visit(self)
  end
end

class Unit
  attr_accessor :health, :armored

  def initialize(params)
    @health = params[:health]
    @armored = params.fetch(:armored, false)
  end
end

class Marine < Unit
  include Visitable

  def initialize
    super(health: 100)
  end
end

class Marauder < Unit
  include Visitable

  def initialize
    super(health: 125, armored: true)
  end
end

class Visitor
  def visit(unit)
    raise NotImplementedError.new
  end

  def visit_light(unit)
    raise NotImplementedError.new
  end

  def visit_armored(unit)
    raise NotImplementedError.new
  end
end

class TankBullet < Visitor
  def visit(unit)
    unit.armored ? visit_armored(unit) : visit_light(unit)
  end

  def visit_light(unit)
    unit.health -= 21
  end

  def visit_armored(unit)
    unit.health -= 32
  end
end