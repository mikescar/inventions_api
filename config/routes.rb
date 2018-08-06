Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :bits, only: [:index]
      resources :inventions, except: [:index]
    end
  end

  match '*path', to: 'application#handle_404', via: :all
end
