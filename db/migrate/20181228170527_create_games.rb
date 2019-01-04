class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.boolean :running
      t.boolean :waiting

      t.timestamps
    end
  end
end
