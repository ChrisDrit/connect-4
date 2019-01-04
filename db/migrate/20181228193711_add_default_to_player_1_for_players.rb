class AddDefaultToPlayer1ForPlayers < ActiveRecord::Migration[5.2]
  def change
    change_column :players, :player_1, :boolean, default: false
  end
end
