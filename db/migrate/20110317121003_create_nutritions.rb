class CreateNutritions < ActiveRecord::Migration

  def self.up
    create_table :nutritions do |t|
      t.integer :ingredient_id
      t.integer :serving_id, :added_by_id
      t.float :fiber, :protein, :fat, :sugar, :sodium, :calories, :carbohydrate, :saturated_fat

      t.timestamps
    end
    add_index :nutritions, :ingredient_id
    add_index :nutritions, :serving_id
    add_index :nutritions, :added_by_id
  end

  def self.down
    drop_table :nutritions
  end

end
