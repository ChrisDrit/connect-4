class AddRowToGameBoard < ActiveRecord::Migration[5.2]
  def change
    add_column :game_boards, :row, :string
  end
end
