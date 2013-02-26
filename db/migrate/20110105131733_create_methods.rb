class CreateMethods < ActiveRecord::Migration

  def self.up
    create_table :methods do |t|
      t.integer :recipe_id
      t.integer :step
      t.float :time_required

      t.timestamps
    end
    add_index :methods, :recipe_id
  end

  def self.down
    drop_table :methods
  end

end
