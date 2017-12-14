class ConsumerTestConsumer < Racecar::Consumer
  subscribes_to "greetings"

  def process(message)
    data = eval(message.value)

    drivers = Driver.joins(:driver_locations)
    drivers = drivers.where("driver_locations.status = 'online'")
    drivers = drivers.where("drivers.service_type = '#{data[:service_type]}'")

    drivers = drivers.order("RANDOM()").first

    puts "Received Data = #{data}"
    puts "YOUR DRIVER WILL BE = #{drivers.username}"
  end
end
