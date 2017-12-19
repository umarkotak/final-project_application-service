module Tools
  def request_json(url)
    request = HTTP.get(url).to_s
    request = JSON.parse(request)
  end

  def initiate_kafka
    @kafka = Kafka.new(
      seed_brokers: ['127.0.0.1:9092'],
      client_id: 'goride',
    )
    @message = {}
  end

  def apikey
    "AIzaSyAxXs-AipMveHRNInl7P3HubboAWgK4aqU"
  end

  def get_coordinate(location_name)
    result = {}
    request = request_json("https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name.gsub(' ','+')}+&key=#{apikey}")

    result[:lat] = request["results"][0]["geometry"]["location"]["lat"]
    result[:lng] = request["results"][0]["geometry"]["location"]["lng"]
    result
  end
end