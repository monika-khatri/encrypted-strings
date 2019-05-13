Rails.application.routes.draw do
  scope module: 'api' do
    scope module: 'v1' do
      resources :encrypted_strings, param: :token, only: [:create, :show, :destroy]
      post '/data_encrypting_keys/rotate', to: 'key_rotations#create'
      get '/data_encrypting_keys/rotate/status', to: 'key_rotations#show'
    end
  end


  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
