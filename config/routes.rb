Rails.application.routes.draw do
  root 'sessions#new' 

  controller :sessions do
    get 'login' => :new
    post 'login' => :create

    get 'login_driver' => :new_driver
    post 'login_driver' => :create_driver    

    delete 'logout' => :destroy
  end

  resources :drivers do
    member do
      get 'topup'
      patch 'topup' => :set_topup
      get 'job'
      post 'job' => :do_job
    end
  end
  
  resources :users do
    member do
      get 'topup'
      patch 'topup' => :set_topup
    end
  end

  controller :orders do
    get 'orders/confirm_order' => :confirm_order
    post 'orders/micro_order' => :micro_order
  end
  resources :orders

  controller :driver_locations do
    post 'orders/micro_create_driver_location' => :micro_create_driver_location 
  end
  resources :driver_locations

end
