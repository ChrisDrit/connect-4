require 'rails_helper'

RSpec.describe Player, type: :model do

  let(:game_board) {GameBoard.new}
  let(:game) {Game.new}
  subject {described_class.new(game: game, game_board: game_board)}

  describe 'associations' do
    it 'belongs_to game_board' do
      game_board.player = subject
      expect(game_board.save).to be_truthy
    end

    it 'belongs_to game' do
      game.players << subject
      expect(game.save!).to be_truthy
    end
  end

  describe 'after_create' do
    it 'changes game state to waiting for player 1' do
      player_1 = 0
      game.save
      game_board.save
      expect(game.waiting).to be_falsey
      expect(game.running).to be_falsey

      Player.create(game: game, game_board: game_board, number: player_1)
      expect(Game.last.waiting).to be_truthy
      expect(Game.last.running).to be_falsey
    end

    it 'changes game state to running for player 2' do
      player_2 = 1
      game.save
      game_board.save
      expect(game.waiting).to be_falsey
      expect(game.running).to be_falsey

      Player.create(game: game, game_board: game_board, number: player_2)
      expect(Game.last.waiting).to be_falsey
      expect(Game.last.running).to be_truthy
    end

    it 'has no game state for any player' do
      game.save
      expect(game.waiting).to be_falsey
      expect(game.running).to be_falsey
    end
  end

  describe '#next_player' do
    it 'returns 0 (player 1) when current player is player 2' do
      subject.number = 1
      expect(subject.next_player).to eq 0
    end

    it 'returns 1 (player 2) when current player is player 1' do
      subject.number = 0
      expect(subject.next_player).to eq 1
    end
  end

  describe '#is_player_1?' do
    it 'returns true when current player is player 1' do
      subject.number = 0
      expect(subject.is_player_1?).to eq true
    end

    it 'returns false when current player is NOT player 1' do
      subject.number = 1
      expect(subject.is_player_1?).to eq false
    end
  end

  describe '#set_game_state' do

    it 'sets game to waiting when player 1' do
      player_1 = 0
      game.save
      game_board.save
      expect(game.waiting).to be_falsey
      expect(game.running).to be_falsey

      Player.create(game: game, game_board: game_board, number: player_1)
      expect(Game.last.waiting).to be_truthy
      expect(Game.last.running).to be_falsey
    end

    it 'sets game to running when player 2' do
      player_2 = 1
      game.save
      game_board.save
      expect(game.waiting).to be_falsey
      expect(game.running).to be_falsey

      Player.create(game: game, game_board: game_board, number: player_2)
      expect(Game.last.waiting).to be_falsey
      expect(Game.last.running).to be_truthy
    end
  end

end
