Rails.application.routes.draw do
  resources :encrypted_strings, param: :token, except: [:new, :edit, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
