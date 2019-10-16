require_relative '../../app/lib/bitboard.rb'

RSpec.describe Bitboard do
  let(:default_bitboard) { "0000000000000000000000000000000000000000000000000000000000000000" }

  describe '.initialize' do
    it 'creates default row' do
      game = Bitboard.new(bitboard: default_bitboard)
      expect(game.row).to eq([0, 7, 14, 21, 28, 35, 42])
    end
  end

  describe '.make_move' do
    context 'with new moves on each of the 7 columns' do
      describe 'with a blank bitboard' do
        let(:game) { Bitboard.new(bitboard: default_bitboard) }

        before :each do
          expect(game.row).to eq([0, 7, 14, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000000000000000000")
        end

        it 'column 1 success' do
          game.make_move(column: 0)

          expect(game.row).to eq([1, 7, 14, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000000000000000001")
        end

        it 'column 2 success' do
          game.make_move(column: 1)

          expect(game.row).to eq([0, 8, 14, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000000000010000000")
        end

        it 'column 3 success' do
          game.make_move(column: 2)

          expect(game.row).to eq([0, 7, 15, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000100000000000000")
        end

        it 'column 4 success' do
          game.make_move(column: 3)

          expect(game.row).to eq([0, 7, 14, 22, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000001000000000000000000000")
        end

        it 'column 5 success' do
          game.make_move(column: 4)

          expect(game.row).to eq([0, 7, 14, 21, 29, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000010000000000000000000000000000")
        end

        it 'column 6 success' do
          game.make_move(column: 5)

          expect(game.row).to eq([0, 7, 14, 21, 28, 36, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000100000000000000000000000000000000000")
        end

        it 'column 7 success' do
          game.make_move(column: 6)

          expect(game.row).to eq([0, 7, 14, 21, 28, 35, 43])
          expect(game.bitboard).to eq("0000000000000000000001000000000000000000000000000000000000000000")
        end
      end

      describe 'with existing bitboard' do
        let(:existing_bitboard) { "0000000000000000000000000000000000000000000000000000000010000000" }
        let(:existing_row) { [0, 8, 14, 21, 28, 35, 42] }
        let(:game) { Bitboard.new(bitboard: existing_bitboard, row: existing_row) }

        before do
          expect(game.row).to eq([0, 8, 14, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000000000010000000")
        end

        it 'column 1 success' do
          game.make_move(column: 0)

          expect(game.row).to eq([1, 8, 14, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000000000010000001")
        end

        it 'column 2 success' do
          game.make_move(column: 1)

          expect(game.row).to eq([0, 9, 14, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000000000110000000")
        end

        it 'column 3 success' do
          game.make_move(column: 2)

          expect(game.row).to eq([0, 8, 15, 21, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000000000000100000010000000")
        end

        it 'column 4 success' do
          game.make_move(column: 3)

          expect(game.row).to eq([0, 8, 14, 22, 28, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000000000001000000000000010000000")
        end

        it 'column 5 success' do
          game.make_move(column: 4)

          expect(game.row).to eq([0, 8, 14, 21, 29, 35, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000000000010000000000000000000010000000")
        end

        it 'column 6 success' do
          game.make_move(column: 5)

          expect(game.row).to eq([0, 8, 14, 21, 28, 36, 42])
          expect(game.bitboard).to eq("0000000000000000000000000000100000000000000000000000000010000000")
        end

        it 'column 7 success' do
          game.make_move(column: 6)

          expect(game.row).to eq([0, 8, 14, 21, 28, 35, 43])
          expect(game.bitboard).to eq("0000000000000000000001000000000000000000000000000000000010000000")
        end
      end
    end
  end
end