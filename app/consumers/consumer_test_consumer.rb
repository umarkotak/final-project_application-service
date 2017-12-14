class ConsumerTestConsumer < Racecar::Consumer
  subscribes_to "request_driver"

  def process(message)
    data = eval(message.value)

    drivers = Driver.joins(:driver_locations)
    drivers = drivers.where("driver_locations.status = 'online'")
    drivers = drivers.where("drivers.service_type = '#{data[:service_type]}'")
    driver = drivers.order("RANDOM()").first

    if driver
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
    else
      sleep(3)
      kafka = Kafka.new(
        seed_brokers: ['127.0.0.1:9092'],
        client_id: 'goride',
      )
      kafka.deliver_message("#{data}", topic: 'request_driver')

      puts "=========================================="
      puts "UNAVAILABLE DRIVER AT THE MOMENT"
      puts "=========================================="
    end
  end
end
