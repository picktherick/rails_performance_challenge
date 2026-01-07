Rails.application.routes.draw do
  resources :orders, only: [:index, :show] do
    collection do
      get :report
      get :summary
      get :search
      get :by_date_range
      get :daily_revenue
      get :orders_by_city
    end
  end

  root 'orders#index'
end
