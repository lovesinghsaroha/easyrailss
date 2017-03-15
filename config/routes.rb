Rails.application.routes.draw do
	mount Esrapr1::Engine => "/esrapr1"
	get "welcome" => "users#welcome"
	post "/user/login" => "users#login"
	post "/user/sign_up" => "users#sign_up"
	get "/user/login" => "users#welcome"
	get "/user/sign_up" => "users#welcome"
    match ':controller(/:action(/:id))', via: [:get, :post]
	root 'users#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
