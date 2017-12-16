class ApplicationConsumer < Racecar::Consumer
  subscribes_to "application"

  def process(message)
    data = eval(message.value)

    if data[:action] == 'send_driver_id'
      set_driver_id_to_order(data)
    end

    puts '================================================='
    puts "ACTION  = #{data[:action]}"
    puts "DATA    = #{data}"
    puts '================================================='
  end

  def set_driver_id_to_order(data)
    order = Order.find(data[:order_id])
    order.driver_id = data[:driver_id]
    order.save
  end
end
