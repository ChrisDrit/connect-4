class GamesController < ApplicationController
  before_action :set_game, :set_player

  def play
  end

  def show
    if @game.ready_player_2?
      @game.set_next_player(@player.id)
      redirect_to game_play_url(game_params[:id])
    end
  end
  
  def move
    if @game.is_my_move?(@player.id)
      @bitboard = @player.game.make_move(@player, game_params[:column])
      @game_grid = @player.game_board.build_game_grid(@bitboard)
      @game.check_set_next_player(@player, @bitboard)

      # TODO find a better home for this group of four stray dogs!
      Pusher.trigger("game-#{@player.game.id}", 'display-move', {message: {player: @player.number, bitboard: @game_grid}})
      Pusher.trigger("game-#{@player.game.id}", 'display-current-player', {message: {player: @player.next_player}})
      Pusher.trigger("game-#{@player.game.id}", 'display-win', {message: {player: @player.number}}) if @bitboard.is_win?
      Pusher.trigger("game-#{@player.game.id}", 'display-draw', {message: ''}) if @bitboard.is_draw?
    else
      @not_my_move = true
    end
    respond_to do |format|
      format.js
    end
  end
  
  private

  def set_game
    @game = Game.find(game_params[:id])
  end

  def set_player
    @player = Player.find(session[:player_id])
  end

  def game_params
    params.permit(:id, :column)
  end
end
