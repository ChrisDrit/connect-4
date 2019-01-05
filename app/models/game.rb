class Game < ApplicationRecord
  has_many :players

  scope :set_waiting, ->(id) {find(id).update_attributes(waiting: true, running: false)}
  scope :set_running, ->(id) {find(id).update_attributes(waiting: false, running: true)}
  scope :last_waiting, -> {where(waiting: true, running: false).order('created_at DESC').limit(1)}
  
  # Make a move on the game grid, save state, and return a Bitboard.
  def make_move(player, column)
    bitboard = Bitboard.new(player.game_board.bits, explode(self.positions))
    bitboard.make_move(column)
    self.update_attributes(positions: collapse(bitboard.row))
    player.game_board.update_attributes(bits: bitboard.bitboard)
    bitboard
  end

  # Explode String into an Array.
  def explode(positions=nil)
    positions.split(',').map(&:to_i) if positions
  end

  # Collapse Array into a String.
  def collapse(positions=nil)
    if positions
      positions = positions.to_s
      positions[0] = '' # remove '['
      positions[-1] = '' # remove ']'
    end
    positions
  end

  # Check if player 2 is game ready
  def ready_player_2?
    self.players.count == 2
  end
  
  # Wrapping `set_next_player` with some conditional logic.
  def check_set_next_player(current_player, bitboard)
    if bitboard.valid_move && bitboard.continue_game_play?
      set_next_player(current_player.id)
    end
  end

  # Query the player opposite of current player.
  # Add that to the next player field.
  def set_next_player(current_player_id)
    next_player = self.players.where('id != ?', current_player_id).first
    self.update_attributes(next_player_id: next_player.id) if next_player
  end

  def is_my_move?(current_player_id)
    current_player_id == self.next_player_id
  end

end
