class ConsumerTestConsumer < Racecar::Consumer
  subscribes_to "request_driver"

  def process(message)
    data = eval(message.value)

    drivers = Driver.joins(:driver_locations)
    drivers = drivers.where("driver_locations.status = 'online'")
    drivers = drivers.where("drivers.service_type = '#{data[:service_type]}'")
    driver = drivers.order("RANDOM()").first

    driver_location = DriverLocation.find_by(driver_id: driver.id)
    driver_location.order_id = data[:order_id]
    driver_location.status = 'busy'
    driver_location.save

    order = Order.find(data[:order_id])
    order.driver = driver
    order.save

    puts "=========================================="
    puts "ORIGINAL MESSAGE    = '#{message.value}'"
    puts "CONVERTED DATA      = #{data}"
    puts "YOUR DRIVER WILL BE = #{driver.username}"
    puts "=========================================="
  end
end
