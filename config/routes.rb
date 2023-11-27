Rails.application.routes.draw do
  root 'profiles#index'
  resources :profiles, only: [:index] do
    resources :chats, only: [:index, :create] do
      post 'send_message', on: :collection  # Add this line
    end
  end
end
