require 'rails_helper'

RSpec.describe Bitboard, type: :libs do

  let(:game) {Game.new}
  let(:player) {Player.new}

  describe "#initialize" do

    before :each do
      @column = 0
      game.positions = "0, 7, 14, 21, 28, 35, 42"
      game.save!
      game_board = GameBoard.create!(bits: GameBoard::DEFAULT_BITBOARD)
      @bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
    end

    it 'successful bitboard binary string' do
      expect(@bitboard.bitboard).to eq GameBoard::DEFAULT_BITBOARD
    end

    it 'successful current_move' do
      @bitboard.make_move(@column)
      expect(@bitboard.current_move).to eq '0000000000000000000000000000000000000000000000000000000000000001'
    end

    it 'successful row' do
      @bitboard.make_move(@column)
      expect(@bitboard.row).to eq [1, 7, 14, 21, 28, 35, 42]
    end

    it 'successful valid_move' do
      @bitboard.make_move(@column)
      expect(@bitboard.valid_move).to be_truthy
    end
  end

  describe "#make_move" do

    before :each do
      @array_of_game_positions = [0, 7, 14, 21, 28, 35, 42]
      game.positions = "0, 7, 14, 21, 28, 35, 42"
      game.save!
      game_board = GameBoard.create!(bits: GameBoard::DEFAULT_BITBOARD)
      @bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
    end

    it 'fails and returns false when no move available' do
      column = 7
      expect(@bitboard.make_move(column)).to be_falsey
    end

    it 'successfully makes a current_move' do
      column = 0
      @bitboard.make_move(column)
      expect(@bitboard.current_move).to eq '0000000000000000000000000000000000000000000000000000000000000001'
    end

    context 'successfully makes a new bitboard binary string for' do
      it 'column 0' do
        column = 0
        @bitboard.make_move(column)
        expect(@bitboard.bitboard).to eq '0000000000000000000000000000000000000000000000000000000000000001'
      end

      it 'column 1' do
        column = 1
        game_board = GameBoard.create!(bits: '0000000000000000000000000000000000000000000000000000000000000001')
        bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
        bitboard.make_move(column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000000000000000000010000001'
      end

      it 'column 2' do
        column = 2
        game_board = GameBoard.create!(bits: '0000000000000000000000000000000000000000000000000000000010000001')
        bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
        bitboard.make_move(column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000000000000100000010000001'
      end

      it 'column 3' do
        column = 3
        game_board = GameBoard.create!(bits: '0000000000000000000000000000000000000000000000000100000010000001')
        bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
        bitboard.make_move(column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000001000000100000010000001'
      end

      it 'column 4' do
        column = 4
        game_board = GameBoard.create!(bits: '0000000000000000000000000000000000000000001000000100000010000001')
        bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
        bitboard.make_move(column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000001000000100000010000001'
      end

      it 'column 5' do
        column = 5
        game_board = GameBoard.create!(bits: '0000000000000000000000000000000000000000001000000100000010000001')
        bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
        bitboard.make_move(column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000001000000100000010000001'
      end

      it 'column 6' do
        column = 6
        game_board = GameBoard.create!(bits: '0000000000000000000000000000000000000000001000000100000010000001')
        bitboard = Bitboard.new(game_board.bits, game.explode(game.positions))
        bitboard.make_move(column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000001000000100000010000001'
      end
    end

    context 'fails to make new bitboard binary string for columns outside of 0 through 6' do
      it 'column 7' do
        column = 7
        @bitboard.make_move(column)
        expect(@bitboard.bitboard).to eq GameBoard::DEFAULT_BITBOARD
      end

      it 'column 8' do
        column = 8
        @bitboard.make_move(column)
        expect(@bitboard.bitboard).to eq GameBoard::DEFAULT_BITBOARD
      end
    end

    context 'successfully increments a columns row for' do
      it 'column 0' do
        column = 0
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq [1, 7, 14, 21, 28, 35, 42]
      end

      it 'column 1' do
        column = 1
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq [0, 8, 14, 21, 28, 35, 42]
      end

      it 'column 2' do
        column = 2
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq [0, 7, 15, 21, 28, 35, 42]
      end

      it 'column 3' do
        column = 3
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq [0, 7, 14, 22, 28, 35, 42]
      end

      it 'column 4' do
        column = 4
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq [0, 7, 14, 21, 29, 35, 42]
      end

      it 'column 5' do
        column = 5
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq [0, 7, 14, 21, 28, 36, 42]
      end

      it 'column 6' do
        column = 6
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq [0, 7, 14, 21, 28, 35, 43]
      end
    end

    context 'fails to increment a columns row for columns outside of 0 through 6' do
      it 'column 7' do
        column = 7
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq @array_of_game_positions
      end

      it 'column 8' do
        column = 8
        @bitboard.make_move(column)
        expect(@bitboard.row).to eq @array_of_game_positions
      end
    end

  end

  # TODO flush out and write these tests!
  pending '#list_moves'
  pending '#is_win?'
  pending '#continue_game_play?'
  pending '#can_move?'
  pending '#is_draw?'
  pending '#columnize'

end