Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :reservations, only: %i[create index show update]
      resources :guests, only: %i[index show]
    end
  end
end
