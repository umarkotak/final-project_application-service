class Order < ApplicationRecord

  validates :user_id, :origin, :destination, :service_type, :payment_type, presence: true
  
  def get_coordinate(location_name)
    result = {}
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name}+&key=AIzaSyD9eO9WPUr-KKTqUM8Q3uzHcZpThY4NIDM"
    request = HTTP.get(url).to_s
    request = JSON.parse(request)
    result[:lat] = request["results"][0]["geometry"]["location"]["lat"]
    result[:lng] = request["results"][0]["geometry"]["location"]["lng"]
    result
  end

  def calculate_data(origin, destination)
    origin = 'empty' if origin == ''
    destination = 'empty' if destination == ''

    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
    distance_matrix = gmaps.distance_matrix(origin, destination)
    status = distance_matrix[:rows][0][:elements][0][:status]

    status == "NOT_FOUND" ? status = false : status = true

    if status
      distance = distance_matrix[:rows][0][:elements][0][:distance][:value] / 1000.0
      self.distance = distance.to_f.round(2)

      if self.service_type == 'gojek'
        self.price = 1500 * self.distance
      else
        self.price = 2500 * self.distance
      end
    end

    status
  end

  private

end
