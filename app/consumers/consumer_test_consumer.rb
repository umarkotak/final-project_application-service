class ConsumerTestConsumer < Racecar::Consumer
  subscribes_to "request_driver"

  def process(message)
    data = eval(message.value)
    # data = {}
    # data[:order_id] = 148
    # data[:service_type] = 'gojek'

    drivers = Driver.joins(:driver_locations)
    drivers = drivers.where("driver_locations.status = 'online'")
    drivers = drivers.where("drivers.service_type = '#{data[:service_type]}'")
    driver = drivers.order("RANDOM()").first

    order = Order.find(data[:order_id])
    order.driver = driver
    order.save

    puts "=========================================="
    puts "ORIGINAL MESSAGE = '#{message.value}'"
    puts "Received Data = #{data}"
    puts "YOUR DRIVER WILL BE = #{driver.username}"
    puts "=========================================="
  end
end
