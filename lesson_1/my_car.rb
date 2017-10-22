# my_car.rb

module SelfDriveable
  
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model
  
  @@number_of_vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def self.number_of_vehicles
    "This program has created #{@@number_of_vehicles} vehicles."
  end

  def speed_up(number)
    @current_speed += number
    puts "You hit the gas and accelerate #{number} mph"
  end

  def brake(number)
    @current_speed -= number
    puts "You hit the brakes and decelerate #{number} mph"
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end
  
  def shut_off
    puts "Let's shut her down."
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def self.calculate_mileage(miles, gallons)
    "Mileage: #{miles / gallons} per gallon."
  end

  def age
    puts "I'm #{calculate_age} years old."
  end

  private

  def calculate_age
    Time.new.year - self.year
  end
end

class MyTruck < Vehicle

  NUMBER_OF_WHEELS = 18

  def to_s
    "I'm a car. I'm a #{self.year} #{self.model} and I'm currently painted #{self.color}."
  end
end

class MyCar < Vehicle

  include SelfDriveable

  NUMBER_OF_WHEELS = 4

  def to_s
    "I'm a car. I'm a #{self.year} #{self.model} and I'm currently painted #{self.color}."
  end
end

stella = MyCar.new(2002, 'black', 'CR-V')
stella.speed_up(20)
stella.current_speed
stella.speed_up(30)
stella.current_speed
stella.brake(20)
stella.current_speed
stella.brake(30)
stella.current_speed
stella.shut_off
MyCar.calculate_mileage(13, 351)
stella.spray_paint('purple')
puts stella
stella.age
puts MyCar.ancestors
puts MyTruck.ancestors
puts Vehicle.ancestors

