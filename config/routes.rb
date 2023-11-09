Rails.application.routes.draw do
  resources :scales, only: [:index, :show], param: :scale
end
