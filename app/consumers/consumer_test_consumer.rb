class ConsumerTestConsumer < Racecar::Consumer
  subscribes_to "greetings"

  def process(message)
    puts "Received message: #{message.value}"
  end
end
