Rails.application.routes.draw do
  root 'sessions#new'

  resources :drivers
  resources :users

  controller :sessions do
    get 'login' => :new
    post 'login' => :create

    get 'login_admin' => :new_admin
    post 'login_admin' => :create_admin    

    delete 'logout' => :destroy
  end

end
