require 'rails_helper'

RSpec.describe GameBoard, type: :model do

  describe 'associations' do
    subject {described_class.new}
    let(:player) {Player.new}

    it 'has_one player' do
      subject.player = player
      expect(subject.save).to be_truthy
    end
  end

  describe 'constants' do
    it 'sets a default, empty bitboard binary string' do
      expect(GameBoard::DEFAULT_BITBOARD).to eq '000000000000000000000000000000000000000000000000000000000000000'
    end
  end

  describe '#build_game_grid' do
    subject {described_class.create}
    let(:bits) {'000000000000000000000000000000000000000000000000000000000000000'}
    let(:current_move) {'000000000000000000000000000000000000000000000000000000000000001'}
    let(:row) {[0, 7, 14, 21, 28, 35, 42]}
    let(:bitboard) {Bitboard.new(bits, row)}
    
    it 'succeeds & returns a columnized bitboard in JSON format and is html_safe' do
      allow_any_instance_of(Bitboard).to receive(:current_move).and_return(current_move)
      json = JSON.parse(subject.build_game_grid(bitboard))
      json_results = {'0'=>'1000000', '1'=>'0000000', '2'=>'0000000', '3'=>'0000000', '4'=>'0000000', '5'=>'0000000'}
      expect(json).to eq(json_results)
    end

    it 'fails and returns nil without a bitboard.current_move' do
      allow_any_instance_of(Bitboard).to receive(:current_move).and_return(nil)
      expect(subject.build_game_grid(bitboard)).to eq nil
    end
  end

end
