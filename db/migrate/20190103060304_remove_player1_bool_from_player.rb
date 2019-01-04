class RemovePlayer1BoolFromPlayer < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :player_1
  end
end
