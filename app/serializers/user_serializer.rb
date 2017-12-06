class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :password, :full_name, :email, :phone, :address, :credit
end
