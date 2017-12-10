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
    end
  end
  
  resources :users do
    member do
      get 'topup'
      patch 'topup' => :set_topup
    end
  end

  resources :orders
  post '/orders/confirm_order' => 'orders#confirm_order'

end
