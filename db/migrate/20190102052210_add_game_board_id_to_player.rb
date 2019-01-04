class AddGameBoardIdToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :game_board_id, :integer
    add_index :players, :game_board_id
  end
end
