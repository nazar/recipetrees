class NurtitionMoreFields < ActiveRecord::Migration

  def self.up
    add_column :nutritions, :cholesterol, :float
    add_column :nutritions, :serving_url, :string
  end

  def self.down
    remove_column :nutritions, :cholesterol
    remove_column :nutritions, :serving_url
  end

end
