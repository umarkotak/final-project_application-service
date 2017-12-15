class ConsumerTestConsumer < Racecar::Consumer
  subscribes_to "request_driver"

  def process(message)
    data = eval(message.value)

    driver_locations = DriverLocation.where("status = 'online'")
    driver_locations = driver_locations.where("service_type = '#{data[:service_type]}'")
    driver_locations = driver_locations.select do |driver_location|
      destination = [driver_location.lat.to_f, driver_location.lng.to_f]
      origin = [data[:origin][:lat], data[:origin][:lng]]
      get_distance(origin, destination) < 20.0
    end
    
    driver_location = driver_locations.sample

    if driver_location
      driver_location.order_id = data[:order_id]
      driver_location.status = 'busy'
      driver_location.save

      order = Order.find(data[:order_id])
      order.driver_id = driver_location.driver_id
      order.save

      puts "=========================================="
      puts "CONVERTED DATA      = #{data}"
      puts "DRIVER ID           = #{driver_location.driver_id}"
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

  def get_distance(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    result = rm * c # Delta in meters
    result = result / 1000
  end
end
