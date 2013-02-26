class MeasureRatio < ActiveRecord::Migration

  def self.up
    add_column :measures, :ratio, :float
  end

  def self.down
    remove_column :measures, :ratio
  end

end
