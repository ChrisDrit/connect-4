class PlayerController < ApplicationController
  before_action :set_game
  
  def create
    player_number = @game.players.count
    board = GameBoard.create(bits: GameBoard::DEFAULT_BITBOARD)
    player = Player.create(game_board: board, number: player_number, game_id: @game.id)
    session[:player_id] = player.id

    # TODO too many puppies, let's find them a better home.
    Pusher.trigger('show-game-grid', 'refresh-page', {message: {refresh: true}}) unless player.is_player_1?
    Pusher.trigger('join-game', 'refresh-page', {message: {refresh: true}}) if player.is_player_1?

    redirect_to game_path(@game.id)
  end

  private

  def set_game
    @game = Game.last_waiting.first
    @game = Game.create unless @game
  end

end
