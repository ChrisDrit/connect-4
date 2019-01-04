class AddIntegerTypeForNextPlayerIdToGame < ActiveRecord::Migration[5.2]
  def change
    change_column :games, :next_player_id, :integer
  end
end
