class RemoveRowFromGameBoard < ActiveRecord::Migration[5.2]
  def change
    remove_column :game_boards, :row
  end
end
