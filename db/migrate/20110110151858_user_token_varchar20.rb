class UserTokenVarchar20 < ActiveRecord::Migration

  def self.up
    change_column :users, :token, :string, {:limit => 20}
  end

  def self.down
    change_column :users, :token, :string, {:limit => 10}
  end

end
