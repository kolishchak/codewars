module ValuesValidator
  def valid?
    self.value.is_a?(valid_type) && self.valid_values.include?(value)
  end
end

class Level
  include ValuesValidator

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def valid_values
    (0..3)
  end

  def valid_type
    Integer
  end
end

class Button
  include ValuesValidator

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def valid_values
    ('0'..'3')
  end

  def valid_type
    String
  end
end

class Elevator
  REMAIN_LEVEL = 0

  attr_reader :level, :button

  def initialize(level, button)
    @level = Level.new(level)
    @button = Button.new(button)
  end

  def call
    return REMAIN_LEVEL if erroneous_input?
    up_down_level
  end

  private

  def erroneous_input?
    !(level.valid? && button.valid?)
  end

  def up_down_level
    button.value.to_i - level.value
  end
end

def goto(level, button)
  Elevator.new(level, button).call
end