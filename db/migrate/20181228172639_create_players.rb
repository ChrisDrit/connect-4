class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.integer :game_id
      t.string :name
      t.boolean :player_1

      t.timestamps
    end
  end
end
