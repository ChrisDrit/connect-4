class CreateGameBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :game_boards do |t|
      t.string :bits

      t.timestamps
    end
  end
end
