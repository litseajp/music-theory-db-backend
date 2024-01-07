Rails.application.routes.draw do
  resources :scales, only: [:index, :show], param: :scale

  resources :chords, only: [:index, :show], param: :chord
end
