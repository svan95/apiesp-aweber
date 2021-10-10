Rails.application.routes.draw do
  resources :contacts do
    get :token, on: :collection
    post :send_to_aweber, on: :collection
  end

  root 'contacts#index'
end
