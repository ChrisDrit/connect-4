class AddCurrentPlayerIdToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :current_player_id, :integer
  end
end
