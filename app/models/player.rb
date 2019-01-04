class Player < ApplicationRecord
  belongs_to :game
  belongs_to :game_board
  after_create :set_game_state

  # Player numbers are either 0 or 1
  # representing player 1 or player 2.
  # Convenient for Bitwise XOR operations :)
  def next_player
    self.number ^ 1
  end
  
  def is_player_1?
    self.number == 0
  end

  # Super simple state triggered by which
  # player (0 or 1) has just been created.
  def set_game_state
    if self.number == 0
      Game.set_waiting(self.game_id)
    else
      Game.set_running(self.game_id)
    end
  end

end
