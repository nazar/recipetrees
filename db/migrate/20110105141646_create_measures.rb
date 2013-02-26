class CreateMeasures < ActiveRecord::Migration

  def self.up
    create_table :measures do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :measures
  end

end
