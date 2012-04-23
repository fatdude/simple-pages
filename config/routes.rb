Rails.application.routes.draw do  
  namespace :admin do
    resources :pages do
      resources :pages, only: [:new, :create]

      collection do
        put :save_order
      end
    end
  end
  
  match ":permalink", to: "pages#show"
end
