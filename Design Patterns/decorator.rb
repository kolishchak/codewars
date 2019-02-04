class Marine
  attr_accessor :damage, :armor

  def initialize(damage, armor)
    @damage = damage
    @armor = armor
  end
end

class MarineDecorator < SimpleDelegator
  def initialize(marine)
    @marine = marine
    super
  end
end

class MarineWeaponUpgrade < MarineDecorator
  def damage
    @marine.damage + 1
  end

end

class MarineArmorUpgrade < MarineDecorator
  def armor
    @marine.armor + 1
  end
end

Marine_weapon_upgrade = MarineWeaponUpgrade
Marine_armor_upgrade = MarineArmorUpgrade
