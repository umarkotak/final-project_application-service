class HomeController < ApplicationController
  skip_before_action :authorize
  skip_before_action :verify_authenticity_token
  
  def index
    
  end
end
