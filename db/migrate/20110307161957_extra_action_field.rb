class ExtraActionField < ActiveRecord::Migration

  def self.up
    add_column :activities, :extra, :string, {:limit => 200}
  end

  def self.down
    remove_column :activities, :extra
  end

end
