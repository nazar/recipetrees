class CreateCookingMethods < ActiveRecord::Migration

  def self.up
    create_table :cooking_methods do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :cooking_methods
  end

end
