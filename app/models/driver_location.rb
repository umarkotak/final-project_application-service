class DriverLocation < ApplicationRecord
  belongs_to :driver
  belongs_to :order, optional: true

  validates :driver_id, :service_type, :location, :lat, :lng, :status, presence: true
  validates :driver_id, uniqueness: true
  validates :status, inclusion: { in: %w(online offline busy), message: "%{value} is not a valid status type"  }
  validate :validate_location

  def apikey
    "AIzaSyAxXs-AipMveHRNInl7P3HubboAWgK4aqU"
  end

  def get_coordinate(location_name)
    request = request_json("https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name.gsub(' ','+')}+&key=#{apikey}")

    self.lat = request["results"][0]["geometry"]["location"]["lat"]
    self.lng = request["results"][0]["geometry"]["location"]["lng"]
  end

  private
    def validate_location
      if location != nil && location != ''
        # Setup API keys
        begin
          gmaps = GoogleMapsService::Client.new(key: apikey)
          distance_matrix = gmaps.distance_matrix(location, location)
          status = distance_matrix[:rows][0][:elements][0][:status]
          errors.add(:location, "is invalid") if status == "NOT_FOUND"
        rescue
          errors.add(:location, "is invalid") if status == "NOT_FOUND"
        end
      end
    end

    def request_json(url)
      request = HTTP.get(url).to_s
      request = JSON.parse(request)
    end
end
