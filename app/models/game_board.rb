class GameBoard < ApplicationRecord
  has_one :player

  DEFAULT_BITBOARD = '000000000000000000000000000000000000000000000000000000000000000'.freeze
  
  # Break bitboard into columns and create safe json
  # ready for returning to the front end display.
  def build_game_grid(bitboard)
    return bitboard.columnize.to_json.html_safe if bitboard.current_move
    nil
  end
  
end
