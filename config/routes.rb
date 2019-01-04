Rails.application.routes.draw do
  post 'player/create'
  post 'game/move', to: 'games#move', as: 'game_move'
  get 'game/:id', to: 'games#show', as: 'game'
  get 'game/play/:id', to: 'games#play', as: 'game_play'
  get 'home', to: 'home#index'
  
  root to: 'home#index'
end
