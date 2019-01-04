require 'rails_helper'

RSpec.describe Game, type: :model do

  subject {described_class.new}

  describe 'Associations' do
    it 'has_many players' do
      Player.create!(game: subject, game_board: GameBoard.create!)
      expect(subject.save!).to be_truthy
    end

    it 'has 1 player' do
      Player.create!(game: subject, game_board: GameBoard.create!)
      subject.save!
      expect(subject.players.count).to eq 1
    end

    it 'has more than 1 player' do
      Player.create!(game: subject, game_board: GameBoard.create!)
      Player.create!(game: subject, game_board: GameBoard.create!)
      subject.save!
      expect(subject.players.count).to be > 1
    end

  end

  describe 'Scopes' do

    describe "scope: set_waiting" do
      it "scopes for setting games to a waiting state" do
        subject.waiting = true
        subject.running = false
        subject.save!
        expect(Game.set_waiting(subject.id)).to be_truthy
        game = Game.last
        expect(game.waiting).to be_truthy
        expect(game.running).to be_falsey
      end
    end

    describe "scope: set_running" do
      it "scopes for setting games to a running state" do
        subject.waiting = false
        subject.running = true
        subject.save!
        expect(Game.set_running(subject.id)).to be_truthy
        game = Game.last
        expect(game.waiting).to be_falsey
        expect(game.running).to be_truthy
      end
    end
  end

  describe '#make_move' do

    it 'succeeds & returns a valid bitboard' do
      subject.positions = "0, 7, 14, 21, 28, 35, 42"
      subject.save!

      bits = '0000000000000000000000000000000000000000000000000000000000000001'
      game_board = GameBoard.create!(bits: bits)
      player = Player.create!(game: subject, game_board: game_board)

      column = 0
      bitboard = subject.make_move(player, column)
      expect(bitboard.row).to eq [1, 7, 14, 21, 28, 35, 42]
      expect(bitboard.current_move).to eq bits
      expect(bitboard.valid_move).to be_truthy
    end

    context 'fails incrementing positions for columns outside 0 though 6' do
      before :each do
        subject.positions = '0, 7, 14, 21, 28, 35, 42'
        subject.save!
        game_board = GameBoard.create!(bits: GameBoard::DEFAULT_BITBOARD)
        @player = Player.create!(game: subject, game_board: game_board)
      end

      it 'columns outside of game board range' do
        column = 7
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 7, 14, 21, 28, 35, 42]
        expect(Game.last.positions).to eq '0, 7, 14, 21, 28, 35, 42'
        expect(bitboard.valid_move).to be_falsey

        column = 8
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 7, 14, 21, 28, 35, 42]
        expect(Game.last.positions).to eq '0, 7, 14, 21, 28, 35, 42'
        expect(bitboard.valid_move).to be_falsey
      end
    end

    context 'succeeds incrementing positions based upon' do

      before :each do
        subject.positions = '0, 7, 14, 21, 28, 35, 42'
        subject.save!
        game_board = GameBoard.create!(bits: GameBoard::DEFAULT_BITBOARD)
        @player = Player.create!(game: subject, game_board: game_board)
      end

      it 'column 0' do
        column = 0
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [1, 7, 14, 21, 28, 35, 42]
        expect(Game.last.positions).to eq '1, 7, 14, 21, 28, 35, 42'
        expect(bitboard.valid_move).to be_truthy
      end

      it 'column 1' do
        column = 1
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 8, 14, 21, 28, 35, 42]
        expect(Game.last.positions).to eq '0, 8, 14, 21, 28, 35, 42'
        expect(bitboard.valid_move).to be_truthy
      end

      it 'column 2' do
        column = 2
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 7, 15, 21, 28, 35, 42]
        expect(Game.last.positions).to eq '0, 7, 15, 21, 28, 35, 42'
        expect(bitboard.valid_move).to be_truthy
      end

      it 'column 3' do
        column = 3
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 7, 14, 22, 28, 35, 42]
        expect(Game.last.positions).to eq '0, 7, 14, 22, 28, 35, 42'
        expect(bitboard.valid_move).to be_truthy
      end

      it 'column 4' do
        column = 4
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 7, 14, 21, 29, 35, 42]
        expect(Game.last.positions).to eq '0, 7, 14, 21, 29, 35, 42'
        expect(bitboard.valid_move).to be_truthy
      end

      it 'column 5' do
        column = 5
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 7, 14, 21, 28, 36, 42]
        expect(Game.last.positions).to eq '0, 7, 14, 21, 28, 36, 42'
        expect(bitboard.valid_move).to be_truthy
      end

      it 'column 6' do
        column = 6
        bitboard = subject.make_move(@player, column)
        expect(bitboard.row).to eq [0, 7, 14, 21, 28, 35, 43]
        expect(Game.last.positions).to eq '0, 7, 14, 21, 28, 35, 43'
        expect(bitboard.valid_move).to be_truthy
      end
    end

    context 'fails returning a new binary string for columns outside 0 through 6' do
      before :each do
        subject.positions = '0, 7, 14, 21, 28, 35, 42'
        subject.save!
        game_board = GameBoard.create!(bits: GameBoard::DEFAULT_BITBOARD)
        @player = Player.create!(game: subject, game_board: game_board)
      end

      it 'column 7' do
        column = 7
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '000000000000000000000000000000000000000000000000000000000000000'
        expect(bitboard.current_move).to be_falsey
        expect(bitboard.valid_move).to be_falsey
      end

      it 'column 8' do
        column = 8
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '000000000000000000000000000000000000000000000000000000000000000'
        expect(bitboard.current_move).to be_falsey
        expect(bitboard.valid_move).to be_falsey
      end

    end

    context 'succeeds and returns a valid bitboard binary string for' do
      before :each do
        subject.positions = '0, 7, 14, 21, 28, 35, 42'
        subject.save!
        game_board = GameBoard.create!(bits: GameBoard::DEFAULT_BITBOARD)
        @player = Player.create!(game: subject, game_board: game_board)
      end

      it 'column 0' do
        column = 0
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000000000000000000000000001'
      end

      it 'column 1' do
        column = 1
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000000000000000000010000000'
      end

      it 'column 2' do
        column = 2
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000000000000100000000000000'
      end

      it 'column 3' do
        column = 3
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000000000001000000000000000000000'
      end

      it 'column 4' do
        column = 4
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000000000010000000000000000000000000000'
      end

      it 'column 5' do
        column = 5
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '0000000000000000000000000000100000000000000000000000000000000000'
      end

      it 'column 6' do
        column = 6
        bitboard = subject.make_move(@player, column)
        expect(bitboard.bitboard).to eq '0000000000000000000001000000000000000000000000000000000000000000'
      end

    end

  end

  describe '#explode' do
    it 'successfully turns a String into an Array' do
      positions = '0, 7, 14, 21, 28, 35, 42'
      expect(subject.explode(positions)).to eq [0, 7, 14, 21, 28, 35, 42]
    end

    it 'fails to turn a String into an Array' do
      positions = nil
      expect(subject.explode(positions)).to be_falsey
    end
  end

  describe '#collapse' do
    it 'successfully turns an Array into a String' do
      positions = [0, 7, 14, 21, 28, 35, 42]
      expect(subject.collapse(positions)).to eq '0, 7, 14, 21, 28, 35, 42'
    end

    it 'fails to turn an Array into a String' do
      positions = nil
      expect(subject.collapse(positions)).to be_falsey
    end
  end

  describe '#ready_player_2?' do
    it 'succeeds with player 2 ready' do
      Player.create!(game: subject, game_board: GameBoard.create!, number: 0)
      Player.create!(game: subject, game_board: GameBoard.create!, number: 1)
      expect(subject.ready_player_2?).to be_truthy
    end

    it 'fails with player 2 not ready' do
      Player.create!(game: subject, game_board: GameBoard.create!, number: 0)
      expect(subject.ready_player_2?).to be_falsey
    end
  end

  describe '#check_set_next_player' do
    it 'succeeds setting the next player' do
      column = 0
      player_1 = 0
      player_2 = 1
      subject.positions = "0, 7, 14, 21, 28, 35, 42"
      bits = '0000000000000000000000000000000000000000000000000000000000000001'
      subject.save!

      Player.create!(game: subject, game_board: GameBoard.create!(bits: bits), number: player_2)
      current_player = Player.create!(game: subject, game_board: GameBoard.create!(bits: bits), number: player_1)

      bitboard = subject.make_move(current_player, column)
      subject.check_set_next_player(current_player, bitboard)

      expect(Game.last.next_player_id).to eq player_2
    end

    it 'fails to set the next player because we have no valid move' do
      column = 7
      player_1 = 0
      player_2 = 1
      subject.positions = "0, 7, 14, 21, 28, 35, 42"
      bits = '0000000000000000000000000000000000000000000000000000000000000001'
      subject.save!

      Player.create!(game: subject, game_board: GameBoard.create!(bits: bits), number: player_2)
      current_player = Player.create!(game: subject, game_board: GameBoard.create!(bits: bits), number: player_1)

      bitboard = subject.make_move(current_player, column)
      subject.check_set_next_player(current_player, bitboard)

      expect(Game.last.next_player_id).to be_falsey
    end

    it 'fails to set the next player because continue_game_play is false' do
      column = 7
      player_1 = 0
      player_2 = 1
      subject.positions = "0, 7, 14, 21, 28, 35, 42"
      bits = '0000000000000000000000000000000000000000000000000000000000000001'
      subject.save!

      Player.create!(game: subject, game_board: GameBoard.create!(bits: bits), number: player_2)
      current_player = Player.create!(game: subject, game_board: GameBoard.create!(bits: bits), number: player_1)

      bitboard = subject.make_move(current_player, column)
      subject.check_set_next_player(current_player, bitboard)

      expect(Game.last.next_player_id).to be_falsey
      expect(bitboard.continue_game_play?).to be_falsey
    end
  end

  describe '#set_next_player' do
    it 'succeeds with 2 players' do
      player_1 = 0
      player_2 = 1
      subject.save!
      Player.create!(game: subject, game_board: GameBoard.create!, number: player_2)
      current_player = Player.create!(game: subject, game_board: GameBoard.create!, number: player_1)
      subject.set_next_player(current_player)

      expect(Game.last.next_player_id).to eq player_2
    end

    it 'fails with only 1 player' do
      player_1 = 0
      subject.save!
      current_player = Player.create!(game: subject, game_board: GameBoard.create!, number: player_1)
      subject.set_next_player(current_player)

      expect(Game.last.next_player_id).to be_falsey
    end
  end

  describe '#is_my_move?' do
    it 'returns true' do
      player_1 = 0
      player_2 = 1
      subject.next_player_id = player_2
      current_player = Player.create!(game: subject, game_board: GameBoard.create!, number: player_1)
      expect(subject.is_my_move?(current_player.id)).to be_truthy
    end

    it 'returns false without a next_player_id already set' do
      player_1 = 0
      subject.next_player_id = nil
      current_player = Player.create!(game: subject, game_board: GameBoard.create!, number: player_1)
      expect(subject.is_my_move?(current_player.id)).to be_falsey
    end

    it 'returns false with a nextd_player_id set to current_player_id'  do
      player_1 = 0
      subject.next_player_id = player_1
      current_player = Player.create!(game: subject, game_board: GameBoard.create!, number: player_1)
      expect(subject.is_my_move?(current_player.id)).to be_falsey
    end
  end

end
