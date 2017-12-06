class DriverSerializer < ActiveModel::Serializer
  attributes :id, :username, :password, :full_name, :email, :phone, :address, :type, :credit
end
