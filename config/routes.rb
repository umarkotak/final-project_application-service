Rails.application.routes.draw do
  root 'sessions#new' 

  resources :drivers
  resources :users

  controller :sessions do
    get 'login' => :new
    post 'login' => :create

    get 'login_driver' => :new_driver
    post 'login_driver' => :create_driver    

    delete 'logout' => :destroy
  end

end
