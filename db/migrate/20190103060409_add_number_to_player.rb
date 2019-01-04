class AddNumberToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :number, :integer
  end
end
