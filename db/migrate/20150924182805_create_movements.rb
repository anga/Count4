class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :state
      t.integer :user
      t.integer :last_movement

      t.timestamps
    end
  end
end
