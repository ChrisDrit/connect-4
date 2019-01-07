class ChangeCurrentPlayerIdToNextPlayerIdForGame < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :current_player_id, :next_player_id
  end
end
