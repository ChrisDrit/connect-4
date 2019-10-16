# -----------------------------------------------------------------------
# Bitboard
#
# I've ported this class into Ruby from the high-level discussion and
# pseudo-code found here:
#
# https://github.com/denkspuren/BitboardC4/blob/master/BitboardDesign.md
#
# It's recommended to review that document if you need to familiarize
# yourself with the concept of Bitboards.
#
# It's a short, but great overview!
#
# ~= TL;DR =~
#
# Two Bitboards, one for each player of the game. Our Bitboard is
# representing 64 bits and is referred to as a Binary String.
#
# Bitboard Binary String:
#
# 0000000000000000000000000000000000000000000000000000000000000000
#
# We use super speedy Bitwise Operations to convert from a Binary
# String to numbers that represent positions within a Game Grid.
#
# Bitboard Game Grid:
#
# +---------------------+
# | 5 12 19 26 33 40 47 |
# | 4 11 18 25 32 39 46 |
# | 3 10 17 24 31 38 45 |
# | 2  9 16 23 30 37 44 |
# | 1  8 15 22 29 36 43 |
# | 0  7 14 21 28 35 42 |
# +---------------------+
#   0  1  2  3  4  5  6
#        (columns)
#
# The numbers inside the Bitboard Game Grid are the
# positions for each game play.
#
# +---------------------+
# |                     | top row
# |                     |
# |                     |
# | O                   |
# | X                   |
# | X     X             | bottom row
# +---------------------+
#   0  1  2  3  4  5  6
#        (columns)
#
# Superimpose this on top of the Bitboard Game Grid
# and we can see that player 'X' has pieces in position
# 0, 1, and 14. Player "O" has a piece in position 2.
#
# This information is stored in the Binary String, so
# player O's would look like this:
#
# 0000000000000000000000000000000000000000000000000000000000000100
#                                                              ^
#                                                         position 2
#
# Sweet! :)
#
class Bitboard

  attr_reader :bitboard, :current_move, :row, :valid_move

  def initialize(bitboard, row)

    # The Bitboard passed in is the current players
    # saved game. This is the players game board in
    # it's current state with all of their moves.
    @bitboard = bitboard

    # @single_bit
    #
    # Representing a single binary bit of
    # 0's and 1's. Used for Bitwise Shift operations.
    #
    # `.to_i(2)`
    # Converts the string of 1's and 0's into an integer
    # value equaling the binary string. Doing this since
    # Ruby seems to lack a true Long Integer?
    #
    # More:
    #
    # => https://www.calleerlandsson.com/posts/rubys-bitwise-operators
    # => https://ruby-doc.org/core-2.5.0/Integer.html#method-i-to_s
    #
    @single_bit = (('0' * 62) << '1').to_i(2)

    # @row
    #
    # Row serves as state for where the next
    # move goes given the column. Defaulting
    # to the bottom row in an empty Bitboard.
    #
    # +---------------------+
    # | 5 12 19 26 33 40 47 | top row
    # | 4 11 18 25 32 39 46 |
    # | 3 10 17 24 31 38 45 |
    # | 2  9 16 23 30 37 44 |
    # | 1  8 15 22 29 36 43 |
    # | 0  7 14 21 28 35 42 | bottom row
    # +---------------------+
    #
    @row = (row && row.any?) ? row : [0, 7, 14, 21, 28, 35, 42]


    # We'll need to access the current move just
    # made as a binary string once completed.
    @current_move = nil

    # We may have selected a column with
    # all rows filled toggling this to true.
    @valid_move = false

  end

  def make_move(column)

    # cast
    column = column.to_i

    # short-circuit
    return false unless can_move?(column)

    # @current_move
    #
    # Bitwise Shift (<<) a single binary bit to the position
    # via the column passed in. This is our new move represented
    # in a Binary String.
    #
    # Bitboard Game Grid
    # +---------------------+
    # | 5 12 19 26 33 40 47 |
    # | 4 11 18 25 32 39 46 |
    # | 3 10 17 24 31 38 45 |
    # | 2  9 16 23 30 37 44 |
    # | 1  8 15 22 29 36 43 |
    # | 0  7 14 21 28 35 42 |
    # +---------------------+
    #
    # Examples Shifting positions (found in @row[column]) 7, 0, 21, and 22 onto the Game Grid:
    #
    # @single_bit:            0000000000000000000000000000000000000000000000000000000000000001
    # (@single_bit << 7):     0000000000000000000000000000000000000000000000000000000010000000
    # (@single_bit << 0):     0000000000000000000000000000000000000000000000000000000000000001
    # (@single_bit << 21):    0000000000000000000000000000000000000000001000000000000000000000
    # (@single_bit << 22):    0000000000000000000000000000000000000000010000000000000000000000
    #
    # `sprintf('%064b')`
    #
    # Format the results to pad with zeros totaling 64 chars (bits)
    # returning the string to represent a binary format. Am I missing
    # something or is there no true Long Integer in Ruby?
    #
    # More:
    # => http://ruby-doc.org/core-2.5.0/Kernel.html#method-i-sprintf
    #
    @current_move = sprintf('%064b', (@single_bit << @row[column]))

    # @bitboard
    #
    # Update Bitboard w/@current_move for one player
    #
    # Bitwise XOR (^) the current Bitboard saved for this player
    # with the @current_move variable from above. This replaces
    # all 0's found in the current Bitboard with 1's found in the
    # @current_move signifying the new game state for this player.
    #
    # Examples:
    #
    # @current_move:      0000000000000000000000000000000000000000000000000000000010000000
    # current Bitboard: ^ 0000000000000000000000000000000000000000000000000000000000000000
    #                   ------------------------------------------------------------------
    # new Bitboard:       0000000000000000000000000000000000000000000000000000000010000000
    #
    # @current_move:      0000000000000000000000000000000000000000000000000000000000000001
    # current Bitboard: ^ 0000000000000000000000000000000000000000000000000000000010000000
    #                   ------------------------------------------------------------------
    # new Bitboard:       0000000000000000000000000000000000000000000000000000000010000001
    #
    # @current_move:      0000000000000000000000000000000001000000000000000000000000000000
    # current Bitboard: ^ 0000000000000000000000000000000000000000000000000000000010000001
    #                   ------------------------------------------------------------------
    # new Bitboard:       0000000000000000000000000000000001000000000000000000000010000001
    #
    # New Bitboard Binary String converted to a Game Grid:
    #
    # 0 0000000 0000000 0000000 0000000 0000100 0000000 0000000 0000001 0000001
    #                    col 6   col 5   col 4   col 3   col 2   col 1   col 0
    #
    # Game Grid               row 6 (extra row)
    # +---------------------+
    # |                     | row 5
    # |                     | row 4
    # |                     | row 3
    # |             X       | row 2
    # |                     | row 1
    # | X  X                | row 0
    # +---------------------+
    #   0  1  2  3  4  5  6
    #        (columns)
    #
    # 
    # Bu-Bam!
    #
    @bitboard = sprintf('%064b', (@bitboard.to_i(2) ^ @current_move.to_i(2)))

    # Position tracking
    #
    # +---------------------+
    # | 5 12 19 26 33 40 47 |
    # | 4 11 18 25 32 39 46 |
    # | 3 10 17 24 31 38 45 |
    # | 2  9 16 23 30 37 44 |
    # | 1  8 15 22 29 36 43 |
    # | 0  7 14 21 28 35 42 |
    # +---------------------+
    #
    # For example if @row = [0, 7, 14, 21, 28, 35, 42]
    # and column = 3 then @row[column] = 21
    #
    # [0, 7, 14, 21, 28, 35, 42]
    #             ^
    #           col 3
    #
    # Then @row[column] += 1
    #
    # [0, 7, 14, 22, 28, 35, 42]
    #             ^
    #           col 3
    #
    # And '22' will be our next available position on the
    # Bitboard Game Grid when column 3 is selected by any player.
    #
    @row[column] += 1

  end

  # Without passing in arguments can
  # we continue with the game?
  def continue_game_play?
    !is_win? && @valid_move
  end

  # Is the move passed in valid?
  def can_move?(column)
    @valid_move = list_moves.include? column
    return false if (!@valid_move || is_draw? || is_win?)
    true
  end

  # No more moves available and we don't yet
  # have a winner, it's a draw!
  def is_draw?
    return true if (list_moves.count <= 0) && !is_win?
    false
  end

  # is_win?
  #
  # This can be refactored to call less Bitwise operations but
  # leaving it verbose does not have a big speed impact (today),
  # yet it significantly helps readability.
  #
  # The "magic" difference numbers on the Bitboard are 1, 6, 7 and 8.
  #
  # Example:
  #
  # +---------------------+
  # | 5 12 19 26 33 40 47 |
  # | 4 11 18 25 32 39 46 |
  # | 3 10 17 24 31 38 45 |
  # | 2  9 16 23 30 37 44 |
  # | 1  8 15 22 29 36 43 |
  # | 0  7 14 21 28 35 42 |
  # +---------------------+
  #
  # Horizontal (-)
  #
  # Let's see if positions 11, 18, 25, and 32 are a four in a row
  # match. To do this, we can see that the difference of each number
  # is 7. So 11+7=18, 18+7=25, 25+7=32. Using Bitwise AND operator
  # we can quickly check if all values are set to 1.
  #
  #
  # Diagonal (\)
  #
  # Let's see if positions 5, 11, 17, and 23 are a four in a row match.
  # To do this, we can see that the difference of each number is 6. So
  # 5+6=11, 11+6=17, 17+6=23. Bitwise AND it and we very quickly
  # understand if all those positions are set to 1.
  #
  # This is great (and speedy) when building a Single Player Mode as
  # the computer's AI would need to rip through all possible game plays after each
  # move to understand the best play it could make.
  #
  # "On a machine crunching 2 billion instructions per second, we can run 50
  # million checks of isWin per second (assuming 40 instructions per check).
  # That's quite a number."
  #
  # Slick...
  #
  def is_win?
    bitboard = @bitboard.to_i(2)
    return true if (bitboard & (bitboard >> 6) & (bitboard >> 12) & (bitboard >> 18) != 0) # diagonal \
    return true if (bitboard & (bitboard >> 8) & (bitboard >> 16) & (bitboard >> 24) != 0) # diagonal /
    return true if (bitboard & (bitboard >> 7) & (bitboard >> 14) & (bitboard >> 21) != 0) # horizontal -
    return true if (bitboard & (bitboard >> 1) & (bitboard >> 2) & (bitboard >> 3) != 0) # vertical |
    false
  end

  # columnize
  #
  # We want to take the Bitboards binary string and break it up
  # into columns. This allows us to loop columns for display of
  # the Bitboard. We also remove the first 15 MSB's as we don't
  # use those for raw display of the Game Grid.
  #
  # Example:
  #
  # Bitboard:    0000000000000000000000000000000000000000010000001
  # Columnized:  0000000 0000000 0000000 0000000 0000000 0000001 0000001
  #               col 6   col 5   col 4   col 3   col 2   col 1   col 0
  #
  # * Once the front-end is fixed up as a proper Game Grid there will
  # * be no use for the utter silliness that is the columnize method ;)
  # * ~hashtag silly
  #
  def columnize
    columnized = {}
    bits = self.current_move[15..63]
    bits = bits.reverse
    bits = (bits.scan(/.{7}/))
    bits.each_with_index do |col, index|
      columnized[index] = col
    end
    columnized
  end

  #
  # Return an Array of available columns for a next move.
  #
  # For example, if all columns are playable
  # the resulting Array of columns looks like:
  #
  # list_moves = [0, 1, 2, 3, 4, 5, 6]
  #
  # When we've filled all rows for a column, then we have
  # no more valid moves in this column and it's removed
  # from the list.
  #
  # Example:
  #
  # If the game grid with player moves looks like
  # this (player 1 = 'X', player 2 = 'O'):
  #
  # +---------------------+
  # | X                   |
  # | X                   |
  # | O                   |
  # | O                   |
  # | X               O   |
  # | X    O   O      X   |
  # +---------------------+
  #   0  1  2  3  4  5  6
  #        (columns)
  #
  # Then there are no more valid moves for column 0.
  # If we Bitwise AND the `top` variable with our move, it
  # looks like this:
  #
  # top:      1000000100000010000001000000100000010000001000000
  # move:  &  0000000000000000000000000000000000000000001000000
  #        -----------------------------------------------------
  #           0000000000000000000000000000000000000000001000000
  #                                                     ^
  #                               (hint: position 6 from below)
  #
  # Where did the value for `top` come from!?
  #
  #   6 13 20 27 34 41 48   The Magic Top Row
  # +---------------------+
  # | 5 12 19 26 33 40 47 |
  # | 4 11 18 25 32 39 46 |
  # | 3 10 17 24 31 38 45 |
  # | 2  9 16 23 30 37 44 |
  # | 1  8 15 22 29 36 43 |
  # | 0  7 14 21 28 35 42 |
  # +---------------------+
  #   0  1  2  3  4  5  6
  #        (columns)
  #
  # The top row has positions 6,13,20,27,34,41,48 and is the hidden
  # row outside of the viewable Game Grid. If we've got position 6
  # filled then we immediately know that column 0 is no longer playable.
  #
  # Since the Bitwise AND operation resulted in a 1 for column 0
  # it is NOT added to the Array of available moves.
  #
  # list_moves = [1, 2, 3, 4, 5, 6]
  #
  # All of our moves are saved in the `@row` variable. A quick
  # loop (7 iterations) with a Bitwise Shift and a Bitwise
  # AND operation gives us what we need :)
  #
  # Impressive.
  #
  def list_moves
    moves = []
    top = '1000000100000010000001000000100000010000001000000'.to_i(2)
    0.upto(6) do |column|
      new_move = (@single_bit << @row[column])
      if ((top & new_move) == 0)
        moves << column
      end
    end
    moves

  end
end
